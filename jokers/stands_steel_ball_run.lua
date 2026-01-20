-- Steel Ball Run Stands

local mandom = {
    name = "mandom",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {retriggers = 1, card_max = 6, cards = 0}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.retriggers, center.ability.extra.cards, center.ability.extra.card_max, center.ability.extra.card_max - center.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.repetition and not context.end_of_round and context.cardarea == G.play and card.ability.extra.cards < card.ability.extra.card_max then
            if not context.blueprint then
                card.ability.extra.cards = card.ability.extra.cards + 1
            end
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card
            }
            end
        if context.end_of_round and not context.individual and not context.repetition then
            card.ability.extra.cards = 0
        end
    end
}


return {
    name = "Stardust Crusaders Stand Jokers",
    list = { mandom },
}