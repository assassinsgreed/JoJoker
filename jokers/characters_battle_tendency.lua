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
                message = localize('$').."$",
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
                    message = localize{type = 'variable', key = 'a_xmult', vars = {Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = Xmult
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
    end,
    in_pool = function(self, args)
        return not args or args.source ~= "jud"
    end,
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

return {
    name = "Battle Tendency Character Jokers",
    list = { joseph_joestar, esidisi, speedwagon_bt, caesar, kars_ultimate_lifeform, kars_stopped_thinking },
}