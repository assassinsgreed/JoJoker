-- Load config
local lovely = require("lovely")

-- Load all atlases
-- TODO: Add other parts as jokers use them!
local joker_basic_atlases = {"jojolion"} -- {"phantom_blood", "battle_tendency", "stardust_crusaders", "diamond_is_unbreakable", "golden_wind", "stone_ocean", "steel_ball_run", "jojolion", "the_jojolands", "others"}
local basic_prefix = "AtlasJokers"

for i = 1, #joker_basic_atlases do
    -- Load basic part spritesheet
    local atlas_base = basic_prefix.."_"..joker_basic_atlases[i]
    SMODS.Atlas({
        key = atlas_base,
        path = atlas_base..".png",
        px = 71,
        py = 95
    })

    -- Load other lookup spritesheet
    if joker_basic_atlases[i] ~= "Others" then
        local atlas_lookup = basic_prefix.."_"..joker_basic_atlases[i]
        SMODS.Atlas({
            key = atlas_lookup,
            path = atlas_lookup..".png",
            px = 71,
            py = 95
        })
    end
end
