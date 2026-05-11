-- The JOJOLands Characters

local jodio_joestar = {
    name = "jodio_joestar",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "the_jojolands",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 3 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.money_mod}}
   end,
    calculate = function(self, card, context)
        -- During scoring, each scored gold card gives $3
        if context.joker_main and context.cardarea == G.jokers then
            local gold_count = 0
            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card.config.center == G.P_CENTERS.m_gold then
                    gold_count = gold_count + 1
                end
            end
            if gold_count > 0 then
                sendDebugMessage("Jodio Joestar: Giving $" .. (gold_count * card.ability.extra.money_mod) .. " for " .. gold_count .. " gold cards")
                ease_dollars(gold_count * card.ability.extra.money_mod)
                return {
                    message = localize('$')..(gold_count * card.ability.extra.money_mod),
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}

return {
    name = "The JOJOLands Characters Jokers",
    list = { jodio_joestar },
}