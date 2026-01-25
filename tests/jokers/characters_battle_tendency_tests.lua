--#region Joseph Joestar
Balatest.TestPlay {
    name = 'joseph_does_not_level_up_hand_when_wrong_hand_played',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
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
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
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
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
        Balatest.play_hand { '3S', '3C', '8H', '8D' }
    end,
    assert = function()
        Balatest.assert_chips(502, "Joseph didn't level up 2 pair hand to level 2, after it was played twice")
    end
}
Balatest.TestPlay {
    name = 'joseph_does_not_level_up_two_pair_contained_in_full_house',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(260, "Joseph levelled up Two Pair hand when Full House was played, but should not have")
    end
}
--#endregion
--#region Esidisi
Balatest.TestPlay {
    name = 'esidisi_xmult_does_not_increase_when_score_on_fire',
    category = { 'jokers', 'phantom_blood', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Esidisi Xmult was changed when score did not catch fire")
    end
}
Balatest.TestPlay {
    name = 'esidisi_xmult_increases_when_score_on_fire',
    category = { 'jokers', 'phantom_blood', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 2, "Esidisi didn't increase Xmult when score caught fire")
    end
}
--#endregion