-- Phantom Blood effects

local magician_red = {
    name = "magician_red",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { money_mod = 5 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.money_mod}}
    end,
    calculate = function(self, card, context)
        -- Cache current hand score
        if context.cardarea == G.jokers and context.scoring_hand then
            if G.GAME.chips then
                G.GAME._chips_before_hand = G.GAME.chips
            end
        end

        -- If score catches fire, then earn $5
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if not G.GAME.chips or not G.GAME.blind.chips then return end
            local start = G.GAME._chips_before_hand or 0 -- fallback if missing
            local hand_score = (G.GAME.chips or 0) - start
            sendDebugMessage("Magician's Red: Recognized score at hand start as "..start)
            sendDebugMessage("Magician's Red: Resulting chips are "..hand_score.." and blind chips are "..G.GAME.blind.chips)
            if hand_score > G.GAME.blind.chips then
                -- Destroy magician_red
                ease_dollars(card.ability.extra.money_mod)
                return {
                    message = localize('$').."$",
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}


return {
    name = "Stardust Crusaders Stand Jokers",
    list = { magician_red },
}