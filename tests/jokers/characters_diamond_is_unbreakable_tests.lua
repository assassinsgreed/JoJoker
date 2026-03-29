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
    name = 'yoshikage_kira_decreases_hands_by_1_when_removed',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 1, "Yoshikage Kira didn't decrease hands by 1 when removed")
    end
}
--#endregion

--#region Reimi
Balatest.TestPlay {
    name = 'reimi_creates_random_spectral_card_at_end_of_boss_blind',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    blind = 'bl_wheel',
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 1, "Reimi didn't create a spectral card at the end of the boss blind")
        Balatest.assert_eq(spectrals[1].config.center.set, "Spectral", "Reimi's card wasn't spectral rarity")
    end
}

Balatest.TestPlay {
    name = 'reimi_does_not_create_spectral_card_at_end_of_non_boss_blind',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 0, "Reimi created a spectral card at the end of a non-boss blind")
    end
}

Balatest.TestPlay {
    name = 'reimi_does_not_create_spectral_card_when_consumeables_are_full',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    blind = 'bl_wheel',
    consumeables = { 'c_mars', 'c_earth' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 2, "Reimi created a spectral card when consumeables are already full")
        Balatest.assert_eq(spectrals[1].config.center.set, "Planet", "Reimi replaced an existing consumeable")
        Balatest.assert_eq(spectrals[2].config.center.set, "Planet", "Reimi replaced an existing consumeable")
    end
}
--#endregion