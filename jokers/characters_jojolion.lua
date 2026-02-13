-- Jojolion Characters

local josuke_higashikata_jjl = {
    name = "josuke_higashikata_jjl",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 80 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and next(context.poker_hands['Two Pair']) then
                if context.joker_main then
                    sendDebugMessage("Josuke Higashikata (JJL): Giving "..card.ability.extra.chips.." chips for hand containing Two Pair")
                    return {
                        message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                        colour=G.C.CHIPS,
                        chip_mod=card.ability.extra.chips,
                    }
                end
            end
        end
    end
}

return {
    name = "Jojolion Characters Jokers",
    list = { josuke_higashikata_jjl },
}