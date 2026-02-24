--#region Shizuka
Balatest.TestPlay {
    name = 'shizuka_does_not_level_up_hand_when_wrong_hand_played',
    category = { 'jokers', 'diamond_is_unbreakable', 'shizuka' },
    jokers = { 'j_jojoker_shizuka' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local pair_hand_level = G.GAME.hands["Pair"].level
        Balatest.assert_eq(pair_hand_level, 1, "Pair hand wasn't level 1")
    end
}
Balatest.TestPlay {
    name = 'shizuka_levels_up_hand_3_times_when_correct_hand_played',
    category = { 'jokers', 'diamond_is_unbreakable', 'shizuka' },
    jokers = { 'j_jojoker_shizuka' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 4, "Shizuka didn't level up 2 pair hand after it was played")
    end
}
--#endregion
--#region Yoshikage Kira
Balatest.TestPlay {
    name = 'yoshikage_kira_increases_hands_by_1_when_added',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't increase hands by 1 when added")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_increases_hands_by_1_when_joker_slots_are_filled_with_various_types',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    -- 2 characters, 1 effect, 2 stands
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_shizuka', 'j_jojoker_voice_of_love', 'j_jojoker_crazy_diamond', 'j_jojoker_superfly' },
    hands = 1,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't increase hands by 1 when added")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_increases_hands_by_2_when_joker_slots_are_filled_with_stands',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond', 'j_jojoker_superfly' },
    hands = 1,
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_yoshikage_kira', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Yoshikage Kira to be added via registered hook
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 3, "Yoshikage Kira didn't increase hands by 2 when added")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_increases_hands_from_2_to_3_when_adding_a_stand_joker_to_fill_roster',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond' },
    hands = 1,
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_superfly', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Superfly (stand) to be added via registered hook
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 3, "Yoshikage Kira didn't increase hands from 2 to 3 when adding a stand joker to fill roster")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_does_not_increase_hands_when_adding_a_non_stand_joker_to_fill_roster',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond' },
    hands = 1,
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_shizuka', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Shizuka (character) to be added via registered hook
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't keep hands the same when adding a non-stand joker to fill roster")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_decreases_hands_from_3_to_2_when_selling_a_stand_joker_while_roster_is_filled_with_stands',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond', 'j_jojoker_superfly' },
    hands = 1,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[5] end) -- Sell Superfly (stand)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't decrease hands from 3 to 2 when selling a stand joker while roster is filled with stands")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_decreases_hands_from_3_to_2_when_destroying_a_stand_joker_while_roster_is_filled_with_stands',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond', 'j_jojoker_superfly' },
    hands = 1,
    execute = function()
        SMODS.destroy_cards(G.jokers.cards[5]) -- Destroy Superfly (stand)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't decrease hands from 3 to 2 when destroying a stand joker while roster is filled with stands")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_does_not_decrease_hands_when_selling_a_non_stand_joker_while_roster_is_filled_with_stands',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond', 'j_jojoker_shizuka' },
    hands = 1,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[5] end) -- Sell Shizuka (character)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't keep hands the same when selling a non-stand joker while roster is filled with stands")
    end
}
Balatest.TestPlay {
    name = 'yoshikage_kira_does_not_decrease_hands_when_destroying_a_non_stand_joker_while_roster_is_filled_with_stands',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira', 'j_jojoker_bad_company', 'j_jojoker_red_hot_chili_pepper', 'j_jojoker_crazy_diamond', 'j_jojoker_shizuka' },
    hands = 1,
    execute = function()
        SMODS.destroy_cards(G.jokers.cards[5]) -- Destroy Shizuka (character)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't keep hands the same when destroying a non-stand joker while roster is filled with stands")
    end
}
--#endregion