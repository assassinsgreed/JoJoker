-- Phantom Blood characters

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
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult
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
                    G.GAME.joker_buffer = 0
                    card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    remove(self, card, context)
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
            local addedMult = math.floor(currentChips * 0.2)
            mult = mult + addedMult
            sendDebugMessage("Baron Zeppeli: Cut chips to "..hand_chips.." and added "..addedMult.." to mult, new mult is "..(mult))

            return {
                message = localize("sound_hey_baby"),
                colour = G.C.GOLD,
            }
        end
    end
}

local speedwagon = {
    name = "speedwagon",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_mod }}
    end,
    calculate = function(self, card, context)
        if context.pre_discard then
            ease_dollars(card.ability.extra.money_mod)
            sendDebugMessage("Speedwagon: Gave $"..card.ability.extra.money_mod.." for used discard.")

            return {
                message = localize('$')..card.ability.extra.money_mod,
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

local zombies = {
    name = "zombies",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult_per = 2, current_mult = 2, numerator = 1, denominator = 4, } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.mult_per, center.ability.extra.current_mult, center.ability.extra.numerator, center.ability.extra.denominator }}
    end,
    calculate = function(self, card, context)
        -- On scoring, give mult_per mult for each held joker and calculate (in the event of special jokers)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Zombies: Giving mult of "..card.ability.extra.current_mult.." for count of held zombie jokers.")
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current_mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.current_mult
                }
            end
        end

        -- Potentially duplicate joker at end of small/big blind
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if #G.jokers.cards < G.jokers.config.card_limit then
                sendDebugMessage("Zombies: "..#G.jokers.cards.." jokers in play, below limit of "..G.jokers.config.card_limit..", considering replicating.")
                if SMODS.pseudorandom_probability(card, 'zombies', card.ability.extra.numerator, card.ability.extra.denominator, 'zombies') then
                    sendDebugMessage("Zombies: Replicated!")
                    
                    play_sound('tarot1')
                    local new_card = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_jojoker_zombies", no_edition = true})
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    jojoker_card_duplicated(new_card)

                    return {
                        message = localize("sound_grr")
                    }
                end
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            card.ability.extra.current_mult = card.ability.extra.mult_per ^ get_joker_count("zombies")
        end
    end
}

local straizo = {
    name = "straizo",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_straight = 80, chips_straight_flush = 200 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips_straight, center.ability.extra.chips_straight_flush }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            local hand_chips_map = {
                ["Straight"] = card.ability.extra.chips_straight,
                ["Straight Flush"] = card.ability.extra.chips_straight_flush
            }
            
            if context.joker_main then
                local chips = hand_chips_map[context.scoring_name]
                if chips then
                    sendDebugMessage("Straizo: Giving "..chips.." chips for "..context.scoring_name)
                    return {
                        message = localize{type='variable', key='a_chips', vars={chips}},
                        colour=G.C.CHIPS,
                        chip_mod=chips,
                    }
                end
            end
        end
    end
}

local george_joestar = {
    name = "george_joestar",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_mod }}
    end,
    calc_dollar_bonus = function(self, card)
        local moneyGiven = #G.jokers.cards * card.ability.extra.money_mod
        sendDebugMessage("George Joestar: Giving $"..moneyGiven.." based on count of held jokers.")
        return ease_joker_dollars(card, "George Joestar", moneyGiven, true)
	end
}

local dario_brando = {
    name = "dario_brando",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1, sell_value_mult = 1.2, numerator = 1, denominator = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_mod, center.ability.extra.sell_value_mult, center.ability.extra.numerator, center.ability.extra.denominator }}
    end,
    calculate = function(self, card, context)
        -- Per hand played, steal up to $1 from player money
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint and context.joker_main then
                if G.GAME.dollars > 0 then
                    G.GAME.dollars = G.GAME.dollars - card.ability.extra.money_mod
                    card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.money_mod
                    card:set_cost()
                    G.E_MANAGER:add_event(Event(
                    {
                        func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up')}); return true
                        end
                    }))
                end
            end
        end

        -- On blind end, multiply sell value and potentially destroy self
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
             if SMODS.pseudorandom_probability(card, 'dario_brando', card.ability.extra.numerator, card.ability.extra.denominator, 'dario_brando') then
                sendDebugMessage("Dario Brando: Destroyed by pseudorandom chance at end of blind.")

                G.E_MANAGER:add_event(Event({
                  func = function()
                    G.GAME.joker_buffer = 0
                    card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    remove(self, card, context)
                    return true
                  end
                }))

                return {
                    message = localize("sound_perished")
                }
            else
                card.ability.extra_value = math.floor(card.ability.extra_value * card.ability.extra.sell_value_mult)
                card:set_cost()
                sendDebugMessage("Dario Brando: Multiplied sell value to "..card.ability.extra_value.." at end of round.")
                G.E_MANAGER:add_event(Event(
                {
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up')}); return true
                    end
                }))
            end
        end
    end
}

local erina = {
    name = "erina",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 10 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.mult_mod }}
    end,
    calculate = function(self, card, context)
        -- Gives mult for each Character joker held_in_hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint and context.joker_main then
                local character_count = get_joker_count_by_type("Character")
                local multGiven = character_count * card.ability.extra.mult_mod
                sendDebugMessage("Erina: Giving "..multGiven.." mult for "..character_count.." Character class jokers.")

                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {multGiven}},
                    colour = G.C.MULT,
                    mult_mod = multGiven
                }
            end
        end
    end
}

local jonathan_joestar = {
    name = "jonathan_joestar",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 50 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        -- Gives chips for each unique suit in scored hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint and context.joker_main then
                local unique_suits = {}
                local suit_count = 0

                for i = 1, #context.scoring_hand do
                    sendDebugMessage("Jonathan Joestar: Card suit is "..context.scoring_hand[i].base.suit)
                    if SMODS.has_no_suit(context.scoring_hand[i]) then
                        suit_count = suit_count + 1
                    elseif not unique_suits[context.scoring_hand[i].base.suit] then
                        unique_suits[context.scoring_hand[i].base.suit] = true
                        suit_count = suit_count + 1
                    end
                end
                local unique_suit_count = math.min(suit_count, 4) -- Cap at 4, if multiple wild cards present
                local chips_given = unique_suit_count * card.ability.extra.chips
                sendDebugMessage("Jonathan Joestar: Giving "..chips_given.." chips for "..suit_count.." unique suits (including wild cards, capped at 4).")

                return {
                    message = localize{type = 'variable', key = 'a_chips', vars = {chips_given}},
                    colour = G.C.CHIPS,
                    chip_mod = chips_given
                }
            end
        end
    end
}

local dio_brando = {
    name = "dio_brando",
    rarity = 4,
    cost = 10,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { drain_rate = 5, Xmult = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.drain_rate, center.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        -- Before scoring, drains base chips out of each scoring card
        if context.before and context.scoring_hand then
            local total_drained = 0
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].ability.nominal_drain then
                    -- Card has not been drained yet
                    sendDebugMessage("Dio Brando: Draining card with "..(context.scoring_hand[i].base.nominal or 0).." chips.")
                    total_drained = total_drained + (context.scoring_hand[i].base.nominal - 1 or 0) -- Cards are left with 1 chip after draining 
                    context.scoring_hand[i].ability.nominal_drain = context.scoring_hand[i].base.nominal or 0 -- Mark drained
                end
            end
            local xmult_to_add = (total_drained * card.ability.extra.drain_rate / 100)
            card.ability.extra.Xmult = card.ability.extra.Xmult + xmult_to_add
            sendDebugMessage("Dio Brando: Drained a total of "..total_drained.." chips from scored cards, increasing Xmult by "..xmult_to_add..".")

            return {
                message = localize("sound_wry")
            }
        end

        -- Gives Xmult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local poco = {
    name = "poco",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { score_threshold = 0.20, money_mod = 2 } },
    loc_vars = function(self, info_queue, center)
      -- Description displays the threshold as a percentage
      return {vars = { center.ability.extra.score_threshold * 100, center.ability.extra.money_mod }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local hand_score = SMODS.calculate_round_score()
                local score_ratio = hand_score / G.GAME.blind.chips
                sendDebugMessage("Poco: Resulting chips are "..hand_score.." and blind chips are "..G.GAME.blind.chips.." (ratio of "..score_ratio.." vs "..card.ability.extra.score_threshold..")")

                -- Give money if equal to or below threshold
                if score_ratio <= card.ability.extra.score_threshold then
                    ease_dollars(card.ability.extra.money_mod)
                    return {
                        message = localize('$')..card.ability.extra.money_mod,
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end
}

local tarkus = {
    name = "tarkus",
    rarity = 2,
    cost = 7,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult = 1, Xmult_mod = 0.33, has_bought = false } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.Xmult, center.ability.extra.Xmult_mod },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end

        -- has_bought handling
        if context.open_booster or context.buying_card then
            card.ability.extra.has_bought = true
        end

        if context.ending_shop then
            if not card.ability.extra.has_bought then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                sendDebugMessage("Tarkus: Increased Xmult to "..card.ability.extra.Xmult.." at end of shop phase without any purchases.")
                G.E_MANAGER:add_event(Event(
                {
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up')}); return true
                    end
                }))
            end
            card.ability.extra.has_bought = false
        end
    end
}

return {
    name = "Phantom Blood Character Jokers",
    list = { danny, baron_zeppeli, speedwagon, zombies, straizo, george_joestar, dario_brando, erina, jonathan_joestar, dio_brando, poco, tarkus },
}