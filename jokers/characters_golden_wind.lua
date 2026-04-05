-- Golden Wind characters

local leaky_eye_luca = {
    name = "leaky_eye_luca",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- Each spade gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Spades") then
                if context.other_card.debuff then
                    return {
                        message = localize("k_debuffed"),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                end
            end
        end
    end
}


return {
    name = "Golden Wind Character Jokers",
    list = { leaky_eye_luca },
}