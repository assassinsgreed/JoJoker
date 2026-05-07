-- Jojolion Stands

local soft_and_wet = {
    name = "soft_and_wet",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = false,
    config = { extra = { mult = 0, mult_mod = 10 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult, center.ability.extra.mult_mod}}
   end,
    calculate = function(self, card, context)
        local m_count = 0
        local popped = false

        -- Apply mult
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local enhanced = {}
            local mult_centers = {
                [G.P_CENTERS.m_mult] = true,
                [G.P_CENTERS.m_wild] = true,
                [G.P_CENTERS.m_bonus] = true,
                [G.P_CENTERS.m_stone] = true,
                [G.P_CENTERS.m_steel] = true,
                [G.P_CENTERS.m_glass] = true,
                [G.P_CENTERS.m_gold] = true,
                [G.P_CENTERS.m_lucky] = true,
            }
            for k,v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    
                    if mult_centers[v.config.center] then
                        m_count = m_count + 1
                        popped = true
                        v:set_ability(G.P_CENTERS.c_base, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                v.vampired = nil
                                return true
                            end
                        }))
                    end
                end
            end

            if #enhanced > 0 and m_count > 0 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * m_count
            end
            sendDebugMessage("Soft & Wet removed " .. #enhanced .. " enhancements. Mult is now " .. card.ability.extra.mult)

            if popped then
                popped = false
                return {
                    message = localize("sound_pop")
                }
            end
        end

        -- Sound effect
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}

local paper_moon_king = {
    name = "paper_moon_king",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_pareidolia', config = {} }
      return {vars = {}}
    end
}

local milagro_man = {
    name = "milagro_man",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    calc_dollar_bonus = function(self, card)
        local doubled_up = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)
        sendDebugMessage("Milagro Man: Doubling interest to $"..doubled_up)
        return ease_joker_dollars(card, "Milagro Man", doubled_up, true)
	end
}

local i_am_a_rock = {
    name = "i_am_a_rock",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, center)
      return {key = jojoker_config.use_localized_names and self.key..'_alt' or self.key}
    end,
    calculate = function(self, card, context)
        -- Set unscored cards to stone cards, if they don't have another enhancement
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            for _, unscored_card in pairs(context.full_hand) do
                if not SMODS.in_scoring(unscored_card, context.scoring_hand) then
                    if unscored_card.config.center == G.P_CENTERS.c_base and not unscored_card.debuff and not unscored_card.vampired then
                        sendDebugMessage("I Am A Rock: Unscored card being set to stone")
                        unscored_card:set_ability(G.P_CENTERS.m_stone, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                unscored_card:juice_up()
                                card:juice_up()
                                return {
                                    message = localize('k_upgrade_ex'),
                                    colour = G.C.GOLD
                                }
                            end
                        }))
                    end
                end
            end
        end
    end
}

local california_king_bed = {
    name = "california_king_bed",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.5, Xmult = 1, tracked_hands = {} } },
    loc_vars = function(self, info_queue, center)
     return {
        vars = {center.ability.extra.Xmult_mod, center.ability.extra.Xmult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Before scoring, increase XMult if hand has not been played this round
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint then
                if context.before and card.ability.extra.tracked_hands[context.scoring_name] == nil then
                    card.ability.extra.tracked_hands[context.scoring_name] = true
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    sendDebugMessage("California King Bed: Adding scoring hand '"..context.scoring_name.."' to tracked hands and increasing XMult")
                    return {
                        message = localize('k_upgrade_ex')
                    }
                end

                -- During scoring, give XMult
                if context.joker_main then
                    return {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                        colour = G.C.XMULT,
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            end
        end

        -- When blind ends, reset XMult and pool of tracked hands
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.Xmult = 1
            card.ability.extra.tracked_hands = {}
            sendDebugMessage("California King Bed: Resetting joker at the end of the round.")
        end
    end
}

local doctor_wu = {
    name = "doctor_wu",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        -- Add a stone card to the deck at the start of the blind
        if context.setting_blind then
            SMODS.add_card{ area = G.deck, set = "Enhanced", enhancement = "m_stone" }

            return {
                message = localize("stone_added")
            }
        end
    end
}

local wonder_of_u = {
    name = "wonder_of_u",
    rarity = 4,
    cost = 10,
    jtype = "Stand",
    jclass = "Automatic",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { fresh_rounds = 3, Xmult_mod = 3, rounds_left = 3, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.fresh_rounds, card.ability.extra.Xmult_mod, card.ability.extra.rounds_left, card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        -- On hand scored, give XMult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end

        -- At end of round, decrease rounds left. If 0, reset counter, destroy all jokers, and increase XMult
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
            sendDebugMessage("Wonder of U: Decreasing rounds left to " .. card.ability.extra.rounds_left)

            if card.ability.extra.rounds_left <= 0 then
                card.ability.extra.rounds_left = card.ability.extra.fresh_rounds
                local jokers_to_destroy = {}
                for _, joker in ipairs(G.jokers.cards) do
                    if joker ~= card then
                        jokers_to_destroy[#jokers_to_destroy + 1] = joker
                    end
                end

                sendDebugMessage("Wonder of U: Destroying " .. #jokers_to_destroy .. " jokers and increasing XMult by " .. card.ability.extra.Xmult_mod * #jokers_to_destroy)
                for _, joker in ipairs(jokers_to_destroy) do
                    joker.ability.eternal = false
                    G.GAME.joker_buffer = 0
                    joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    remove(self, joker, context, true)
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                end

                return {
                    message = localize("sound_wonder_of_u"),
                    colour = G.C.GOLD,
                }
            else
                return {
                    message = localize("sound_calamity_approaches"),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

local paisley_park = {
    name = "paisley_park",
    rarity = 3,
    cost = 7,
    jtype = "Stand",
    jclass = "Long Range",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { booster_limit = 1, extra_choices = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = { card.ability.extra.booster_limit, card.ability.extra.extra_choices },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_booster_limit(card.ability.extra.booster_limit)
        G.GAME.extra_booster_picks = (G.GAME.extra_booster_picks or 0) + card.ability.extra.extra_choices
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_booster_limit(-card.ability.extra.booster_limit)
        G.GAME.extra_booster_picks = (G.GAME.extra_booster_picks or 0) - card.ability.extra.extra_choices
    end,
}

local space_trucking = {
    name = "space_trucking",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 2 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.numerator, center.ability.extra.denominator}}
    end,
    calculate = function(self, card, context)
        -- Potentially make held consumeables negative at the start of the shop
        if context.starting_shop then
            for i = 1, #G.consumeables.cards do
                local consumeable = G.consumeables.cards[i]
                if not consumeable.edition or not consumeable.edition.negative then
                    sendDebugMessage("Space Trucking: Found held consumeable, checking for negative conversion")
                    if SMODS.pseudorandom_probability(card, 'space_trucking', card.ability.extra.numerator, card.ability.extra.denominator, 'space_trucking') then
                        sendDebugMessage("Space Trucking: Making held consumeable negative")
                        consumeable:juice_up()
                        consumeable:set_edition('e_negative')
                        play_sound('negative', 1.5, 0.4)
                    end
                end
            end
        end
    end
}

return {
    name = "Jojolion Stands Jokers",
    list = { soft_and_wet, paper_moon_king, milagro_man, i_am_a_rock, california_king_bed, doctor_wu, wonder_of_u, paisley_park, space_trucking },
}