-- Stone Ocean Characters

local savage_garden = {
    name = "savage_garden",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        -- Gives xmult on the final hand 
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and G.GAME.current_round.hands_left == 0 then
                sendDebugMessage("Savage Garden: Applying Xmult to final hand")
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

return {
    name = "Stone Ocean Character Jokers",
    list = { savage_garden },
}