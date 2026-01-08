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

--Custom colors for badges
local jokercolours = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    jokercolours()
  end
  G.ARGS.LOC_COLOURS["stand"] = HEX("22179c")
  G.ARGS.LOC_COLOURS["user"] = HEX("9c1717")
  G.ARGS.LOC_COLOURS["effect"] = HEX("d2d232")
  G.ARGS.LOC_COLOURS["close_range"] = HEX("853424")
  G.ARGS.LOC_COLOURS["long_range"] = HEX("852468")
  G.ARGS.LOC_COLOURS["automatic"] = HEX("24853B")
  return jokercolours(_c, _default)
end

--called to ensure crashes don't happen
loc_colour()
