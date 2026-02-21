-- Stone Ocean Characters

local green_baby = {
    name = "green_baby",
    rarity = 1,
    cost = 3,
    jtype = "Character",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { Xchips = 2 }},
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.Xchips }}
    end,
    calculate = function(self, card, context)
        -- When high card is played, double earned chips
       if context.cardarea == G.jokers and context.scoring_hand and context.scoring_name == "High Card" then
            if context.joker_main then
                sendDebugMessage("Green Baby: Doubling chips for high card")
                hand_chips = hand_chips * card.ability.extra.Xchips

                return {
                    message = localize('sound_gaa')
                }
            end
        end
    end
}

return {
    name = "Stone Ocean Character Jokers",
    list = { green_baby },
}