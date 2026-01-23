-- Phantom Blood effects

local danny = {
    name = "danny",
    rarity = 2,
    cost = 5,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 15 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- During scoring, give 15 mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if G.GAME.chips then
                G.GAME._chips_before_hand = G.GAME.chips
            end
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.mult
                }
            end
        end

        -- If score catches fire, then destroy Danny
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if not G.GAME.chips or not G.GAME.blind.chips then return end
            local start = G.GAME._chips_before_hand or 0 -- fallback if missing
            local hand_score = (G.GAME.chips or 0) - start
            sendDebugMessage("Danny: Recognized score at hand start as "..start)
            sendDebugMessage("Danny: Resulting chips are "..hand_score.." and blind chips are "..G.GAME.blind.chips..". Will "..(hand_score > G.GAME.blind.chips and "" or " not ").." be destroyed.")
            if hand_score > G.GAME.blind.chips then
                -- Destroy Danny        
                G.E_MANAGER:add_event(Event({
                  func = function()
                    remove(self, card, context, true)
                    return true
                  end
                }))
                G.GAME._chips_before_hand = nil

                return {
                    message = localize("sound_yip")
                }
            end
        end
    end
}

local baron_zeppeli = {
    name = "baron_zeppeli",
    rarity = 3,
    cost = 8,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {vars = { }}
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            local currentChips = hand_chips or 0
            hand_chips = math.floor(currentChips / 2)
            local addedMult = math.floor(currentChips * 0.1)
            mult = mult + addedMult
            sendDebugMessage("Baron Zeppeli: Cut chips to "..hand_chips.." and added "..addedMult.." to mult, new mult is "..(mult))

            return {
                message = localize("sound_hey_baby"),
                colour = G.C.GOLD,
            }
        end
    end
}

return {
    name = "Phantom Blood Effect Jokers",
    list = { danny, baron_zeppeli },
}