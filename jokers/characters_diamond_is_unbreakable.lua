-- Diamond is Unbreakable characters

local shizuka = {
    name = "shizuka",
    rarity = 2,
    cost = 4,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.HAND_LEVELS, jojoker.themes.HIGHEST_HAND_LEVEL } },
    similar = { jojoker.similar.RANDOM_HAND_LEVEL_UPS },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { levels = 3, tried_hands = "", chosen_hand_type_name = nil } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.levels, card.ability.extra.tried_hands }}
    end,
    calculate = function(self, card, context)
        -- Level up hand type when played and choose a new one
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                if card.ability.extra.tried_hands == "" then
                    card.ability.extra.tried_hands = context.scoring_name
                else
                    card.ability.extra.tried_hands = card.ability.extra.tried_hands..", "..context.scoring_name
                end

                if context.scoring_name == card.ability.extra.chosen_hand_type_name then
                    jojoker.debug("Shizuka: Leveling up hand "..card.ability.extra.chosen_hand_type_name.." and choosing a new one.")
                    SMODS.upgrade_poker_hands({hands = {card.ability.extra.chosen_hand_type_name}, level_up = card.ability.extra.levels, from = card})
                    card.ability.extra.chosen_hand_type_name = pick_random_hand_type().handname
                    card.ability.extra.tried_hands = ""

                    return {
                        message = localize("sound_gaa")
                    }
                end
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        -- When added, choose a random hand type (only "visible" ones are chosen, i.e. ones the player can/has played)
        card.ability.extra.chosen_hand_type_name = pick_random_hand_type().handname
        jojoker.debug("Shizuka: Chose a new hand type")
        -- jojoker.debug("Shizuka: Chose a new hand type of "..card.ability.extra.chosen_hand_type_name)
    end,
}

local yoshikage_kira = {
    name = "yoshikage_kira",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.HANDS_PLAYED }, support = { jojoker.themes.MADE_IN_HEAVEN } },
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
            jojoker.debug("Yoshikage Kira: Added to deck, increasing hands by "..card.ability.extra.hands)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            ease_hands_played(card.ability.extra.hands)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- Must mirror the from_debuff check in add_to_deck, or each debuff cycle permanently drains a hand
        if not from_debuff then
            jojoker.debug("Yoshikage Kira: Removing from deck, decreasing hands by "..card.ability.extra.hands)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            ease_hands_played(-card.ability.extra.hands)
        end
    end
}

local reimi = {
    name = "reimi",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.CONSUMABLE_ROOM } },
    similar = { jojoker.similar.BOSS_BLIND_REWARDS },
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
                jojoker.debug("Reimi: Creating a "..conname.." Spectral card at the end of boss blind.")

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

local angelo = {
    name = "angelo",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.FACE_CARDS }, support = { jojoker.themes.STONE_CARDS, jojoker.themes.RETRIGGERS } },
    similar = { jojoker.similar.RANK_RETRIGGERS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { retriggers = 2 } },
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
      return {vars = { card.ability.extra.retriggers }}
    end,
    -- If scoring hand has a face and stone card, each retriggers twice
    calculate = function(self, card, context)
        if context.before and has_scoring_face_and_stone(context.scoring_hand) then
            return {
                message = localize("sound_yo_angelo")
            }
        end

        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            local other = context.other_card
            if (other:is_face() or SMODS.has_enhancement(other, 'm_stone')) and has_scoring_face_and_stone(context.scoring_hand) then
                jojoker.debug("Angelo: Retriggering face or stone card")
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

local hayato = {
    name = "hayato",
    rarity = 2,
    cost = 7,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { xmult_mod = 1, draws = 0 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.xmult_mod }}
    end,
    calculate = function(self, card, context)
        -- Cards are turned face up on their way to play, so record their facing before they leave the hand
        if context.press_play and not context.blueprint then
            for _, played_card in ipairs(G.hand.highlighted) do
                played_card.ability.jojoker_played_face_down = played_card.facing == 'back' or nil
            end
        end

        -- Give xmult per flipped card that contributes to the scored poker hand
        if context.joker_main then
            local xmult = get_hayato_xmult(card, context.poker_hands[context.scoring_name][1], context.full_hand)
            if xmult <= 1 then return end
            jojoker.debug("Hayato: Every face down card formed the poker hand, giving X"..xmult)
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {xmult}},
                Xmult_mod = xmult
            }
        end

        if context.after and not context.blueprint then
            for _, played_card in ipairs(context.full_hand) do
                played_card.ability.jojoker_played_face_down = nil
            end
        end
    end
}

return {
    name = "Diamond is Unbreakable Character Jokers",
    list = { shizuka, yoshikage_kira, reimi, angelo, hayato },
}