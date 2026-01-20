--#region Joseph Joestar
Balatest.TestPlay {
    name = 'joseph_does_not_level_up_hand_when_wrong_hand_played',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Pair hand wasn't level 1")
    end
}
Balatest.TestPlay {
    name = 'joseph_levels_up_hand_when_correct_hand_played',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
    end,
    assert = function()
        Balatest.assert_chips(174, "Joseph didn't level up 2 pair hand after it was played")
    end
}
Balatest.TestPlay {
    name = 'joseph_levels_up_hand_multiple_times_per_blind',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
        Balatest.play_hand { '3S', '3C', '8H', '8mmD' }
    end,
    assert = function()
        Balatest.assert_chips(502, "Joseph didn't level up 2 pair hand to level 2, after it was played twice")
    end
}
--#endregion