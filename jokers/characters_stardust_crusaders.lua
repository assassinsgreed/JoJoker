-- Stardust Crusaders Characters

local ndoul = {
    name = "ndoul",
    rarity = 2,
    cost = 7,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_smeared', config = {} }
      return {vars = {}}
    end
}

return {
    name = "Stardust Crusaders Character Jokers",
    list = { ndoul },
}