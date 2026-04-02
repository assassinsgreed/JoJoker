-- Battle Tendency characters

local joseph_joestar = {
    name = "joseph_joestar",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    config = { extra = { chosen_hand_type_name = "undecided", jokerdisplay_hand_name = "a hand" } }, -- Default for displayed strings in desc & jokerdisplay
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.chosen_hand_type_name}}
    end,
    calculate = function(self, card, context)
        -- When blind is starting, choose a random hand type (only "visible" ones are chosen, i.e. ones the player can/has played)
        local hand_options = {}
        local hand_names = {}
        if context.setting_blind then
            for k,v in pairs(G.GAME.hands) do
                if v.visible then
                    local hand = v
                    hand.handname = k
                    table.insert(hand_options, hand)
                    table.insert(hand_names, hand.handname)
                end
            end

            if #hand_options > 0 then
                local hand = hand_options[math.random(#hand_options)]
                card.ability.extra.chosen_hand_type_name = hand.handname
                card.ability.extra.jokerdisplay_hand_name = hand.handname
                sendDebugMessage("Joseph Joestar: Chose hand "..hand.handname.." out of options "..table.concat(hand_names, ", "))
                
                return {
                    message = localize("sound_prediction")
                }
            end
        end

        -- Level up hand type when played
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint then
                if context.before and context.scoring_name == card.ability.extra.chosen_hand_type_name then
                    sendDebugMessage("Joseph Joestar: Leveling up hand "..card.ability.extra.chosen_hand_type_name)
                    SMODS.smart_level_up_hand(card, card.ability.extra.chosen_hand_type_name)
                    return {
                        message = localize('sound_nice')
                    }
                end
            end
        end

        -- When blind ends, reset display strings
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.chosen_hand_type_name = localize("undecided")
            card.ability.extra.jokerdisplay_hand_name = localize("a_hand")
        end
    end
}

local esidisi = {
    name = "esidisi",
    rarity = 3,
    cost = 6,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult = 1, mult_mod = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult, card.ability.extra.mult_mod}}
    end,
    calculate = function(self, card, context)
        -- If score catches fire, give +1 Xmult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                if SMODS.calculate_round_score() > G.GAME.blind.chips then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + 1
                    sendDebugMessage("Esidisi: Score caught fire, increasing Xmult to "..card.ability.extra.Xmult)
                end
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local speedwagon_bt = {
    name = "speedwagon_bt",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_mod }}
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand then
            ease_dollars(card.ability.extra.money_mod)
            sendDebugMessage("Speedwagon: Gave $"..card.ability.extra.money_mod.." for played hand.")

            return {
                message = localize('$')..card.ability.extra.money_mod,
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

local caesar = {
    name = "caesar",
    rarity = 2,
    cost = 4,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 3 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        -- For each scored stone card, give it 3x mult then destroy it
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card.config.center == G.P_CENTERS.m_stone then
                sendDebugMessage("Caesar: Triggering 3x mult on stone card and destroying it")
                remove_playing_card(context.other_card, card)

                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult_mod}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult_mod
                }
            end
        end
    end
}

local kars_ultimate_lifeform = {
    name = "kars_ultimate_lifeform",
    rarity = 4,
    cost = 10,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { Xmult_mod = 2, rounds_until_debuff = 5, Xmult = 1, current_rounds_left = 5 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.rounds_until_debuff, card.ability.extra.Xmult, card.ability.extra.current_rounds_left }}
    end,
    calculate = function(self, card, context)
        -- For each unique planet card played, gains XMult. After 5 rounds, becomes kars_stopped_thinking
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end

        -- At the end of the round, decrease rounds remaining.  If 0, perform transformation to kars_stopped_thinking
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if card.ability.extra.current_rounds_left > 0 then
                card.ability.extra.current_rounds_left = card.ability.extra.current_rounds_left - 1
                sendDebugMessage("Kars (Ultimate Lifeform): Rounds remaining set to "..card.ability.extra.current_rounds_left)

                if card.ability.extra.current_rounds_left == 0 then
                    sendDebugMessage("Kars (Ultimate Lifeform): transforming into Kars (Stopped Thinking)")
                    transform_joker(card, "j_jojoker_kars_stopped_thinking")

                    return {
                        message = localize("sound_stopped_thinking")
                    }
                end
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
            card.ability.extra.Xmult = 1 + planets_used * card.ability.extra.Xmult_mod
        end
    end
}

local kars_stopped_thinking = {
    name = "kars_stopped_thinking",
    rarity = 1,
    cost = 10,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { },
    loc_vars = function(self, info_queue, card)
      return {vars = { }}
    end,
    in_pool = function(self, args)
        return false
    end,
}

local suzi_q = {
    name = "suzi_q",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { },
    loc_vars = function(self, info_queue, card)
      return {
        vars = { },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- For each scored queen, give it a gold seal if it has no other seals
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:get_id() == 12 then
                if context.other_card.seal == nil then
                    sendDebugMessage("Suzie Q: Giving gold seal to scored queen")
                    context.other_card:set_seal("Gold")
                    card:juice_up()
                else
                    sendDebugMessage("Suzie Q: Scored queen already has a seal, skipping")
                end
            end
        end
    end
}

local nypd = {
    name = "nypd",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- Each club gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Clubs") then
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

local santana = {
    name = "santana",
    rarity = 2,
    cost = 5,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 5 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips_mod }}
    end,
    calculate = function(self, card, context)
        -- Permanently gives +5 chips for each scored face card
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_face() then
                if context.other_card.debuff then
                    return {
                        message = localize("k_debuffed"),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips_mod
                    context.other_card:juice_up()
                    sendDebugMessage("Santana: Increasing additional chips of scored face card to "..tostring(context.other_card.ability.perma_bonus))

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

local stroheim = {
    name = "stroheim",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { starting_chips = 100, chips_loss = 10, chips_remaining = 100 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.starting_chips, card.ability.extra.chips_loss, card.ability.extra.chips_remaining }}
    end,
    calculate = function(self, card, context)
        -- Gives chips per played hand, but decreases value. Once value hits 0, evolves to German Engineering
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                -- After scoring, handle decrease in chips and potential evolution
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0,
                func = function()
                    card.ability.extra.chips_remaining = math.max(0, card.ability.extra.chips_remaining - card.ability.extra.chips_loss)
                    sendDebugMessage("Stroheim: Chips remaining decreased to "..card.ability.extra.chips_remaining)

                    if card.ability.extra.chips_remaining == 0 then
                        sendDebugMessage("Stroheim: Chips depleted, transforming into German Engineering")
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('sound_german_engineering')})
                        transform_joker(card, "j_jojoker_stroheim_german_engineering")
                    end
                    return true
                end
            }))

                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips_remaining}},
                    colour=G.C.CHIPS,
                    chip_mod=card.ability.extra.chips_remaining,
                }
            end
        end
    end,
    -- Prevent Stroheim from appearing if his evolved form is present
    in_pool = function(self, args)
        for _, joker in ipairs(G.jokers.cards) do
            if joker.config.center == "j_jojoker_stroheim_german_engineering" then
                return false
            end
        end
        return true
    end,
}

local stroheim_german_engineering = {
    name = "stroheim_german_engineering",
    rarity = 2,
    cost = 7,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { starting_mult = 30, mult_gain = 5, current_mult = 30 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.starting_mult, card.ability.extra.mult_gain, card.ability.extra.current_mult }}
    end,
    calculate = function(self, card, context)
        -- Give mult when scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current_mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.current_mult
                }
            end
        end

        -- On blind end, increase mult gain
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult_gain
            sendDebugMessage("Stroheim (German Engineering): Increasing mult to "..card.ability.extra.current_mult)

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.GOLD
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
}

return {
    name = "Battle Tendency Character Jokers",
    list = { joseph_joestar, esidisi, speedwagon_bt, caesar, kars_ultimate_lifeform, kars_stopped_thinking, suzi_q, nypd, santana, stroheim, stroheim_german_engineering },
}