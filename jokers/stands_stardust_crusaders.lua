-- Stardust Crusaders Stands

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

local yellow_temperance = {
    name = "yellow_temperance",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {retriggers = 1} },
    loc_vars = function(self, info_queue, center)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Retrigger all scored face cards
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card
                }
            end
        end
    end
}

local star_platinum = {
    name = "star_platinum",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.numerator, center.ability.extra.denominator}}
    end,
    calculate = function(self, card, context)
        -- Potentially preserve hand when playing a hand (by adding 1 to remaining hands)
        if context.before and context.scoring_hand then
            if SMODS.pseudorandom_probability(card, 'star_platinum', card.ability.extra.numerator, card.ability.extra.denominator, 'star_platinum') then
                sendDebugMessage("Star Platinum: Preserving hand on played hand")
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1

                return {
                    message = localize("sound_time_moves")
                }
            end
        end
    end
}

local wheel_of_fortune = {
    name = "wheel_of_fortune",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Wheel of Fortune cards are guaranteed to trigger
        if context.fix_probability then
            if context.identifier == 'wheel_of_fortune' then
                sendDebugMessage("Wheel of Fortune is guaranteeing Wheel of Fortune tarot effect (if possible)")
                return {
                    numerator = 1,
                    denominator = 1,
                }
            end
        end
    end
}

local the_lovers = {
    name = "the_lovers",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Long Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 3 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.mult_mod }}
    end,
    calculate = function(self, card, context)
        -- Permanently gives +3 mult to each scored heart card
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") then
                if context.other_card.debuff then
                    return {
                        message = localize("k_debuffed"),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult_mod
                    context.other_card:juice_up()
                    sendDebugMessage("The Lovers: Increasing multiplier of scored heart to "..tostring(context.other_card.ability.perma_mult))

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

return {
    name = "Stardust Crusaders Stand Jokers",
    list = { magician_red, yellow_temperance, star_platinum, wheel_of_fortune, the_lovers },
}