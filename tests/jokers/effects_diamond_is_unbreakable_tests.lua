--#region Voice of Love
Balatest.TestPlay {
    name = 'voice_of_love_gives_no_mult_for_non_heart_cards',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Voice of Love incorrectly gave mult for non-heart card")
    end
}
Balatest.TestPlay {
    name = 'voice_of_love_gives_mult_for_single_heart_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "Voice of Love incorrectly gave mult for single heart card")
    end
}
Balatest.TestPlay {
    name = 'voice_of_love_gives_mult_for_each_scored_heart_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2H', '3H', '5H', '7H', '8H' }
    end,
    assert = function()
        Balatest.assert_chips(60 * (G.jokers.cards[1].ability.extra.mult * 5 + 4), "Voice of Love incorrectly gave mult for multiple scored heart cards")
    end
}
--#endregion