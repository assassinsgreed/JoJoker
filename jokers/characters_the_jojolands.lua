-- The JOJOLands Characters

local jodio_joestar = {
    name = "jodio_joestar",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "the_jojolands",
    themes = { core = { jojoker.themes.STEEL_GOLD_CARDS }, support = { jojoker.themes.MONEY_HELD } },
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
                jojoker.debug("Jodio Joestar: Giving $" .. (gold_count * card.ability.extra.money_mod) .. " for " .. gold_count .. " gold cards")
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

local hacca_howler = {
    name = "hacca_howler",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "the_jojolands",
    themes = { core = { jojoker.themes.MONEY_HELD } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 100, dollars_per = 20 } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.chips_mod,
                center.ability.extra.dollars_per,
                math.floor(math.max(0, G.GAME.dollars) / center.ability.extra.dollars_per) * center.ability.extra.chips_mod
            }
        }
    end,
    calculate = function(self, card, context)
        -- Gives 100 chips for every $20 held, rounded down
        if context.joker_main then
            local chips = math.floor(math.max(0, G.GAME.dollars) / card.ability.extra.dollars_per) * card.ability.extra.chips_mod
            if chips > 0 then
                jojoker.debug("Hacca Howler: Giving " .. chips .. " chips for $" .. G.GAME.dollars .. " held")
                return {
                    message = localize{type='variable', key='a_chips', vars={chips}},
                    colour = G.C.CHIPS,
                    chip_mod = chips,
                }
            end
        end
    end
}

return {
    name = "The JOJOLands Characters Jokers",
    list = { jodio_joestar, hacca_howler },
}