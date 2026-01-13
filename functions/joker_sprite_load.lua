JokerSprites = {
    lookup = {},
    list = {
        -- TODO: Others
        {name = "danny", base = {pos = {x = 0, y = 0}}, part_atlas = "phantom_blood" },
        {name = "goo_goo_dolls", base = {pos = {x = 0, y = 0}}, part_atlas = "stone_ocean" },
        {name = "stone_free", base = {pos = {x = 1, y = 0}}, part_atlas = "stone_ocean" },
        {name = "soft_and_wet", base = {pos = {x = 0, y = 0}}, part_atlas = "jojolion" },
    }
}

for i, sprite in ipairs(JokerSprites.list) do
    JokerSprites.lookup[sprite.name] = i
end

setmetatable(JokerSprites, {
    __index = function(_, key)
        return JokerSprites.list[JokerSprites.lookup[key]]
    end
})

joker_load_sprites = function(item)
    local sprite_info = JokerSprites[item.name]
    local sprite = nil
    local new_pos = {}
    if sprite_info then
        sprite = sprite_info.base
        local position = sprite.pos.x and sprite.pos or nil
        if not position then -- Randomly grab a sprite if we couldn't load one; oops!
            position = sprite.pos[math.random(#sprite.pos)]
        end
        new_pos.x = position.x
        new_pos.y = position.y
        local soul_position = sprite.soul_pos

        if position then item.pos = new_pos end
        if soul_position then item.soul_pos = soul_position end
        sendDebugMessage("loading sprite for "..item.name..": ("..new_pos.x..","..new_pos.y..")")
    end
end

joker_get_atlas_string = function(atlas_prefix, part_atlas, other_atlas)
    sendDebugMessage("Getting atlas string for prefix "..atlas_prefix..", part_atlas "..tostring(part_atlas)..", other_atlas "..tostring(other_atlas))
    if part_atlas then
        return atlas_prefix.."_"..part_atlas -- AtlasJokers_jojolion
    elseif other_atlas then
        return atlas_prefix.."_"..other_atlas -- AtlasJokers_others
    end
end

joker_load_atlas = function(item)
    if JokerSprites[item.name] then
        local sprite_info = JokerSprites[item.name]
        local atlas_prefix = "AtlasJokers" -- We only support a single sprite source currently
        item.atlas = joker_get_atlas_string(atlas_prefix, sprite_info.part_atlas, sprite_info.other_atlas)
        sendDebugMessage("loading atlas for "..item.name..": "..item.atlas)
        if sprite_info.lookup_part_atlas then
            item.jojoker_lookup_atlas = joker_get_atlas_string(atlas_prefix, sprite_info.lookup_part_atlas)
        end
    end
end