-- Diamond is Unbreakable characters

local shizuka = {
    name = "shizuka",
    rarity = 2,
    cost = 4,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { levels = 3, chosen_hand_type_name = nil } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.levels }}
    end,
    calculate = function(self, card, context)
        -- When blind is starting and hand hasn't been chosen yet, choose a random hand type (only "visible" ones are chosen, i.e. ones the player can/has played)
        if context.setting_blind then
            if not card.ability.extra.chosen_hand_type_name then
                local hand = pick_random_hand_type()
                card.ability.extra.chosen_hand_type_name = hand.handname
                sendDebugMessage("Shizuka: Chose a new hand type")
            end
        end

        -- Level up hand type when played and choose a new one
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and next(context.poker_hands[card.ability.extra.chosen_hand_type_name]) then
                sendDebugMessage("Shizuka: Leveling up hand "..card.ability.extra.chosen_hand_type_name.." and choosing a new one.")
                SMODS.upgrade_poker_hands({hands = {card.ability.extra.chosen_hand_type_name}, level_up = card.ability.extra.levels, from = card})
                card.ability.extra.chosen_hand_type_name = pick_random_hand_type().handname
                return {
                    message = localize("sound_gaa")
                }
            end
        end
    end
}

local yoshikage_kira = {
    name = "yoshikage_kira",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { hands = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.hands }}
    end,
    -- Handle when Yoshikage Kira specifically is added/removed from joker pool
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            sendDebugMessage("Yoshikage Kira: Added to deck, increasing hands by "..card.ability.extra.hands)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            ease_hands_played(card.ability.extra.hands)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        sendDebugMessage("Yoshikage Kira: Removing from deck, decreasing hands by "..card.ability.extra.hands)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end
}

local reimi = {
    name = "reimi",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { has_triggered = false, spectrals = { 'c_familiar', 'c_grim', 'c_incantation', 'c_talisman', 'c_aura', 'c_wraith', 'c_sigil', 'c_ouija', 'c_ectoplasm', 'c_immolate', 'c_ankh', 'c_deja_vu', 'c_hex', 'c_trance', 'c_medium', 'c_cryptid', 'c_soul', 'c_black_hole'} } },
    calculate = function(self, card, context)
        -- At the end of boss blinds, create a random Spectral card
        if context.ante_end and not card.ability.extra.has_triggered then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                card.ability.extra.has_triggered = true

                -- Only create a card if there is at least 1 Spectral card type that can be created
                local conname = card.ability.extra.spectrals[math.random(1, #card.ability.extra.spectrals)]
                sendDebugMessage("Reimi: Creating a "..conname.." Spectral card at the end of boss blind.")

                local _card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, conname)
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.PURPLE})
            end
        end

        if context.ending_shop then
            -- Reset trigger for next boss fight
            card.ability.extra.has_triggered = false
        end
    end
}

return {
    name = "Diamond is Unbreakable Character Jokers",
    list = { shizuka, yoshikage_kira, reimi },
}