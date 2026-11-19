local https = require "SMODS.https"

local REPO = SMODS.current_mod.github:match("github%.com/([^/]+/[^/]+)")
local ZIP, MOUNT = "jojoker_update.zip", "jojoker_update"
local STAGING = love.filesystem.getSaveDirectory() .. "/jojoker_update_staging/"
local mod_path = SMODS.current_mod.path

jojoker.updater = {
    installed = SMODS.current_mod.version,
    release = nil,
    state = "idle",
    on_change = nil,
}
local updater = jojoker.updater

local function set_state(state)
    updater.state = state
    if updater.on_change then updater.on_change() end
end

local function strip_v(version)
    return (tostring(version):gsub("^[vV]", ""))
end

function jojoker.updater.check()
    if updater.state ~= "idle" and updater.state ~= "unreachable" then return end
    set_state("checking")
    https.asyncRequest("https://api.github.com/repos/" .. REPO .. "/releases/latest", function(code, body)
        local ok, data = pcall(JSON.decode, body)
        if code == 404 then return set_state("none") end
        if code ~= 200 or not ok or type(data) ~= "table" or not data.tag_name then
            sendErrorMessage("Update check failed with status " .. tostring(code), "JoJoker")
            return set_state("unreachable")
        end
        updater.release = data.tag_name
        set_state(strip_v(updater.release) == strip_v(updater.installed) and "up_to_date" or "available")
    end)
end

local function remove_tree(path)
    path = path:gsub("/$", "")
    local info = NFS.getInfo(path)
    if not info then return end
    if info.type == "directory" then
        for _, name in ipairs(NFS.getDirectoryItems(path)) do
            remove_tree(path .. "/" .. name)
        end
    end
    assert(NFS.remove(path))
end

local function extract_archive(src, dst)
    assert(NFS.createDirectory(dst))
    for _, name in ipairs(love.filesystem.getDirectoryItems(src)) do
        if love.filesystem.getInfo(src .. name).type == "directory" then
            extract_archive(src .. name .. "/", dst .. name .. "/")
        else
            assert(NFS.write(dst .. name, assert(love.filesystem.read(src .. name))))
        end
    end
end

local function copy_tree(src, dst)
    assert(NFS.createDirectory(dst))
    for _, name in ipairs(NFS.getDirectoryItems(src)) do
        if NFS.getInfo(src .. name).type == "directory" then
            copy_tree(src .. name .. "/", dst .. name .. "/")
        else
            assert(NFS.write(dst .. name, assert(NFS.read(src .. name))))
        end
    end
end

local function prune_tree(reference, target)
    for _, name in ipairs(NFS.getDirectoryItems(target)) do
        local wanted = NFS.getInfo(reference .. name)
        if name == ".git" then
        elseif not wanted then
            remove_tree(target .. name)
        elseif wanted.type == "directory" then
            prune_tree(reference .. name .. "/", target .. name .. "/")
        end
    end
end

local function stage(zip_contents)
    love.filesystem.unmount(ZIP)
    assert(love.filesystem.write(ZIP, zip_contents))
    assert(love.filesystem.mount(ZIP, MOUNT), "Could not open downloaded archive")
    local ok, err = pcall(function()
        local root = love.filesystem.getDirectoryItems(MOUNT)[1]
        assert(root, "Downloaded archive is empty")
        remove_tree(STAGING)
        extract_archive(MOUNT .. "/" .. root .. "/", STAGING)
    end)
    love.filesystem.unmount(ZIP)
    love.filesystem.remove(ZIP)
    assert(ok, err)
    assert(NFS.getInfo(STAGING .. "JoJoker.json") and NFS.getInfo(STAGING .. "jojoker.lua"),
        "Downloaded archive is not a JoJoker build")
end

local function install(zip_contents)
    stage(zip_contents)
    copy_tree(STAGING, mod_path)
    prune_tree(STAGING, mod_path)
    remove_tree(STAGING)
end

function jojoker.updater.update()
    if updater.state ~= "available" and updater.state ~= "failed" then return end
    set_state("downloading")
    https.asyncRequest("https://codeload.github.com/" .. REPO .. "/zip/refs/tags/" .. updater.release, function(code, body)
        if code ~= 200 then
            sendErrorMessage("Update download failed with status " .. tostring(code), "JoJoker")
            return set_state("failed")
        end
        local ok, err = pcall(install, body)
        if not ok then
            sendErrorMessage("Update install failed: " .. tostring(err), "JoJoker")
            return set_state("failed")
        end
        SMODS.restart_game()
    end)
end
