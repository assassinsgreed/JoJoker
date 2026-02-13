--#region Leaky Eye Luca
Balatest.TestPlay {
    name = 'leaky_eye_luca_gives_no_mult_for_non_spade_cards',
    category = { 'jokers', 'golden_wind', 'leaky_eye_luca' },
    jokers = { 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Leaky Eye Luca incorrectly gave mult for non-spade card")
    end
}
Balatest.TestPlay {
    name = 'leaky_eye_luca_gives_mult_for_single_spade_card',
    category = { 'jokers', 'golden_wind', 'leaky_eye_luca' },
    jokers = { 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "Leaky Eye Luca incorrectly gave mult for single spade card")
    end
}
Balatest.TestPlay {
    name = 'leaky_eye_luca_gives_mult_for_each_scored_spade_card',
    category = { 'jokers', 'golden_wind', 'leaky_eye_luca' },
    jokers = { 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '5S', '7S', '8S' }
    end,
    assert = function()
        Balatest.assert_chips(60 * (G.jokers.cards[1].ability.extra.mult * 5 + 4), "Leaky Eye Luca incorrectly gave mult for multiple scored spade cards")
    end
}
--#endregion