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
    config = { extra = { hands = 1, hands_all_stands = 2, was_all_stands = false } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.hands, card.ability.extra.hands_all_stands }}
    end,
    calculate = function(self, card, context)
        local joker_added_function = function(joker)
            if #G.jokers.cards == G.jokers.config.card_limit then
                local stand_jokers_count = get_joker_count_by_type("Stand")
                sendDebugMessage("Yoshikage Kira: Count of stand jokers is: "..stand_jokers_count)

                if stand_jokers_count == #G.jokers.cards - 1 then -- Ignore held Yoshikage Kira
                    sendDebugMessage("Yoshikage Kira: All other joker slots are filled with stands, modifying hands to +"..joker.ability.extra.hands_all_stands)
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + joker.ability.extra.hands_all_stands
                    ease_hands_played(joker.ability.extra.hands_all_stands)
                    ease_hands_played(-joker.ability.extra.hands)
                    joker.ability.extra.was_all_stands = true
                end
            end
        end

        -- If all joker slots are filled with stands, modify extra hands
        -- NOTE: Spawning a joker via Judgement causes the new joker to not be seen in these contexts, so we 
        -- delay the computation check to make sure it happens after the game knows about the new joker
        if context.card_added or (context.buying_card and not context.buying_self) then
            sendDebugMessage("Yoshikage Kira: Joker added/bought, counting jokers. Current count is "..#G.jokers.cards.." and config limit is "..G.jokers.config.card_limit)
            joker_added_function(card)
        end

        if context.using_consumeable then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.5, blockable = true,
                func = function()
                    sendDebugMessage("Yoshikage Kira: Joker received via consumable, counting jokers. Current count is "..#G.jokers.cards.." and config limit is "..G.jokers.config.card_limit)
                    joker_added_function(card)
                    return true
                end
            }))
        end

        if context.selling_card or context.joker_type_destroyed then
            if (card.ability.extra.was_all_stands) then
                sendDebugMessage("Yoshikage Kira: Previously all joker slots were filled with stands, modifying hands to +"..card.ability.extra.hands)
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
                ease_hands_played(- (card.ability.extra.hands_all_stands - card.ability.extra.hands))
                card.ability.extra.was_all_stands = false
            end
        end
    end,
    -- Handle when Yoshikage Kira specifically is added/removed from joker pool
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local to_add = card.ability.extra.hands
            local stand_jokers_count = get_joker_count_by_type("Stand")
            if #G.jokers.cards > 0 and stand_jokers_count == #G.jokers.cards then
                to_add = card.ability.extra.hands_all_stands
            end

            sendDebugMessage("Yoshikage Kira: Added to deck, increasing hands by "..to_add)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + to_add
            ease_hands_played(to_add)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        local to_decrease = card.ability.extra.hands
        if card.ability.extra.was_all_stands then
            to_decrease = card.ability.extra.hands_all_stands
        end

        sendDebugMessage("Yoshikage Kira: Removing from deck, decreasing hands by "..to_decrease)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - to_decrease
        ease_hands_played(-to_decrease)
    end
}

return {
    name = "Diamond is Unbreakable Character Jokers",
    list = { shizuka, yoshikage_kira },
}