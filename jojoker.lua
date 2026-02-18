jojoker = {}

-- Get mod and config path
mod_dir = ''..SMODS.current_mod.path
jojoker_config = SMODS.current_mod.config

-- Load the JokerDisplay mod if it is enabled
if (SMODS.Mods["JokerDisplay"] or {}).can_load then
    local jokerDisplays = NFS.getDirectoryItems(mod_dir.."jokerdisplay")

    for _, file in ipairs(jokerDisplays) do
        sendDebugMessage("Loading JokerDisplay file: "..file)
        local helper, load_error = SMODS.load_file("jokerdisplay/"..file)
        if load_error then
            sendDebugMessage("Error loading JokerDisplay file "..file..": "..load_error)
        else
            helper()
        end
    end
end

-- -- Load custom rarities (ex. Joker type)
-- SMODS.Rarity {
--     key = "stand",
--     default_weight = 0,
--     badge_colour = HEX("22179C"), -- Blue
--     pools = {["Joker"] = true},
--     get_weight = function(self, weight, object_type)
--         return weight
--     end,
-- }
-- SMODS.Rarity {
--     key = "character",
--     default_weight = 0,
--     badge_colour = HEX("9C1717"), -- Red
--     pools = {["Joker"] = true},
--     get_weight = function(self, weight, object_type)
--         return weight
--     end,
-- }
-- SMODS.Rarity {
--     key = "effect",
--     default_weight = 0,
--     badge_colour = HEX("FAFA05"), -- Yellow
--     pools = {["Joker"] = true},
--     get_weight = function(self, weight, object_type)
--         return weight
--     end,
-- }
-- -- TODO: Other rarities for things like close range, automatic, etc.

-- Load helper function files
function loadFile(path)
    local helper, load_error = SMODS.load_file(path)
    if load_error then
        sendDebugMessage("Error loading file "..path..": "..load_error)
    else
        helper()
    end
end

-- TODO: Others as they are added
loadFile("functions/joker_order.lua")
loadFile("functions/joker_sprite_load.lua")
loadFile("functions/apifuncs.lua")
loadFile("functions/jokerfunctions.lua")
loadFile("functions/uifunctions.lua")
loadFile("functions/util_functions.lua")
loadFile("jojokerui.lua")
loadFile("jokersprites.lua")
loadFile("quips.lua")

-- Load tests, if Balatest mod is present and active
if Balatest then
    SMODS.load_file('tests/jokers/characters_phantom_blood_tests.lua')()
    SMODS.load_file('tests/jokers/characters_battle_tendency_tests.lua')()
    SMODS.load_file('tests/jokers/effects_battle_tendency_tests.lua')()
    SMODS.load_file('tests/jokers/characters_stardust_crusaders_tests.lua')()
    SMODS.load_file('tests/jokers/stands_stardust_crusaders_tests.lua')()
    SMODS.load_file('tests/jokers/characters_diamond_is_unbreakable_tests.lua')()
    SMODS.load_file('tests/jokers/effects_diamond_is_unbreakable_tests.lua')()
    SMODS.load_file('tests/jokers/stands_diamond_is_unbreakable_tests.lua')()
    SMODS.load_file('tests/jokers/characters_golden_wind_tests.lua')()
    SMODS.load_file('tests/jokers/stands_golden_wind_tests.lua')()
    SMODS.load_file('tests/jokers/stands_stone_ocean_tests.lua')()
    SMODS.load_file('tests/jokers/effects_steel_ball_run_tests.lua')()
    SMODS.load_file('tests/jokers/stands_steel_ball_run_tests.lua')()
    SMODS.load_file('tests/jokers/characters_jojolion_tests.lua')()
    SMODS.load_file('tests/jokers/effects_jojolion_tests.lua')()
    SMODS.load_file('tests/jokers/stands_jojolion_tests.lua')()
    SMODS.load_file('tests/jokers/stands_the_jojolands_tests.lua')()
end

-- Load Jokers
local pfiles = NFS.getDirectoryItems(mod_dir.."jokers")
for _, file in ipairs(pfiles) do
    sendDebugMessage("Loading Jojoker file: "..file)
    local joker, load_error = SMODS.load_file("jokers/"..file)
    if load_error then
        sendDebugMessage("Error loading joker file "..file..": "..load_error)
    else
        local curr_joker = joker()
        if curr_joker.init then curr_joker:init() end

        if curr_joker.list and #curr_joker.list > 0 then
            for _, j in ipairs(curr_joker.list) do
                jojoker.load_joker(j)
            end
        end
    end
end

jojoker.joker_order_groups = {}
G.E_MANAGER:add_event(Event({
    func = function()
        for i, joker in ipairs(jojoker.joker_order) do
            if type(joker) == "table" then
                for _, j in ipairs(joker) do
                    if not G.P_CENTERS['j_jojoker_'..j] and not next (SMODS.deepfind(jojoker.joker_order_groups, j, "v", true)) then
                        jojoker.joker_order_groups[#jojoker.joker_order_groups+1] = {j}
                    end
                end
            elseif not G.P_CENTERS['j_jojoker_'..joker] and not next (SMODS.deepfind(jojoker.joker_order_groups, joker, "v", true)) then
                jojoker.joker_order_groups[#jojoker.joker_order_groups+1] = {joker}
            end
        end
        return true
    end
}))

-- TODO: These
-- Load consumable types
-- Load consumables
-- Load boosters
-- Load seals
-- Load stickers
-- Load editions (? need this?)
-- Load enhancements
-- Load vouchers
-- Load blinds
-- Load tags
-- Load backs
-- Load sleeves
-- Load challenges

-- SMODS overrides

-- Hook SMODS.find_card to add support for finding jokers
local find_card_with_joker = SMODS.find_card
function SMODS.find_card(key, count_debuffed)
	if key == "j_shortcut" then
		return find_joker("Shortcut")
    elseif key == "j_four_fingers" then
        local ret = find_joker("Four Fingers")
        if #ret > 0 then return ret end
    elseif key == "j_pareidolia" then
        local ret = find_joker("Pareidolia")
        if #ret > 0 then return ret end
    elseif key == "j_smeared" then
        local ret = find_joker("Smeared")
        if #ret > 0 then return ret end
    elseif key == "j_splash" then
        local ret = find_joker("Splash")
        if #ret > 0 then return ret end
    end
	return find_card_with_joker(key, count_debuffed)
end
