-- Jojolion Effects

local higashikata_house = {
    name = "higashikata_house",
    rarity = 1,
    cost = 6,
    jtype = "Effect",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 80 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand and context.scoring_name == "Full House" then
            if context.joker_main then
                sendDebugMessage("Higashikata House: Giving "..card.ability.extra.chips.." chips for Full House")
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour=G.C.CHIPS,
                    chip_mod=card.ability.extra.chips,
                }
            end
        end
    end
}

return {
    name = "Jojolion Effects Jokers",
    list = { higashikata_house },
}