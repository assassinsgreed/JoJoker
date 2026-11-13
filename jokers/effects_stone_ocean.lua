-- Stone Ocean Effects

local dios_bone = {
    name = "dios_bone",
    rarity = 2,
    cost = 6,
    jtype = "Effect",
    part = "stone_ocean",
    themes = { support = { jojoker.themes.SCORE_EVERY_CARD } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { card_threshold = 36, Xmult = 2.5, scored_cards_remaining = 36, active = false } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = { center.ability.extra.card_threshold, center.ability.extra.Xmult, center.ability.extra.scored_cards_remaining }
        }
    end,
    calculate = function(self, card, context)
        -- Gives 2.5x mult every 36 scored cards, which spills over to the next activation
        -- Counted before scoring so a copying joker reads the same activation instead of counting twice
        if context.before and not context.blueprint then
            local remaining = card.ability.extra.scored_cards_remaining - #context.scoring_hand
            card.ability.extra.active = remaining <= 0
            if card.ability.extra.active then
                jojoker.debug("DIO's Bone: Reached "..card.ability.extra.card_threshold.." scored cards, with spill-over of "..-remaining)
                remaining = remaining + card.ability.extra.card_threshold
            end
            card.ability.extra.scored_cards_remaining = remaining
        end

        if context.joker_main and card.ability.extra.active then
            jojoker.debug("DIO's Bone: Giving X"..card.ability.extra.Xmult.." mult")
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                colour = G.C.MULT,
                Xmult_mod = card.ability.extra.Xmult,
            }
        end

        if context.after and not context.blueprint then
            card.ability.extra.active = false
        end
    end
}

local snail = {
    name = "snail",
    rarity = 1,
    cost = 1,
    jtype = "Effect",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 10, chips = 0 } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = { center.ability.extra.chips_mod, center.ability.extra.chips }
        }
    end,
    calculate = function(self, card, context)
        -- Gains chips per hand played
        if context.before and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            jojoker.debug("Snail: Increasing chips to "..card.ability.extra.chips)
        end

        if context.joker_main then
            return {
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
                colour = G.C.CHIPS,
                chip_mod = card.ability.extra.chips,
            }
        end
    end,
    -- Only Weather Report's Heavy Weather makes Snails
    in_pool = function(self, args)
        return false
    end,
}

return {
    name = "Stone Ocean Effects Jokers",
    list = { dios_bone, snail },
}
