-- Diamond is Unbreakable effects

local voice_of_love = {
    name = "voice_of_love",
    rarity = 1,
    cost = 5,
    jtype = "Effect",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- Each heart gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") then
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

local ghost_girl_alley = {
    name = "ghost_girl_alley",
    rarity = 2,
    cost = 6,
    jtype = "Effect",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { chips_mod = 10, mult_mod = 1, money_mod = 1 } },
    loc_vars = function(self, info_queue, center)
        local antes = (G.GAME.jojoker_bosses_beaten or 0)
        local extra = center.ability.extra
        return {vars = { extra.chips_mod, extra.mult_mod, extra.money_mod, antes * extra.chips_mod, antes * extra.mult_mod, antes * extra.money_mod }}
    end,
    calculate = function(self, card, context)
        -- Give chips and mult per scored hand
        if context.joker_main then
            local antes = (G.GAME.jojoker_bosses_beaten or 0)
            if antes > 0 then
                return {
                    chips = antes * card.ability.extra.chips_mod,
                    mult = antes * card.ability.extra.mult_mod,
                }
            end
        end

        -- If an ante is reversed, destroy self
        if context.jojoker_ante_reversed and not context.blueprint and not card.getting_sliced then
            sendDebugMessage("Ghost Girl Alley: Ante reversed by "..context.amount..", destroying self")
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    remove(self, card, context)
                    return true
                end
            }))
            return {
                message = localize('k_extinct_ex'),
                colour = G.C.RED
            }
        end
    end,
    -- Give money at the end of the round
    calc_dollar_bonus = function(self, card)
        local payout = (G.GAME.jojoker_bosses_beaten or 0) * card.ability.extra.money_mod
        if payout > 0 then
            sendDebugMessage("Ghost Girl Alley: Giving $"..payout.." for "..(G.GAME.jojoker_bosses_beaten or 0).." antes cleared this run.")
            return ease_joker_dollars(card, "Ghost Girl Alley", payout, true)
        end
    end
}

return {
    name = "Diamond is Unbreakable Effect Jokers",
    list = { voice_of_love, ghost_girl_alley },
}