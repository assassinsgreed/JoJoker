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

local pucci = {
    name = "pucci",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { retriggers = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Retriggers prime ranks
        local prime_ranks = { [2] = true, [3] = true, [5] = true, [7] = true, [11] = true, [13] = true }
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if context.other_card and prime_ranks[context.other_card:get_id()] then
                sendDebugMessage("Pucci: Retriggering on prime rank "..context.other_card:get_id())
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

return {
    name = "Stone Ocean Character Jokers",
    list = { savage_garden, pucci },
}