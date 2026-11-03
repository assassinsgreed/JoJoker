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
--#region Mista
Balatest.TestPlay {
    name = 'mista_gives_chips_and_mult_for_a_scored_4',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((5 + 4 + extra.card_chips) * (1 + extra.card_mult), "Mista did not pay out for a scored 4")
    end
}
Balatest.TestPlay {
    name = 'mista_gives_chips_and_mult_for_four_of_a_kind',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '9S', '9H', '9C', '9D' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((60 + 36 + extra.hand_chips) * (7 + extra.hand_mult), "Mista did not pay out for Four of a Kind")
    end
}
Balatest.TestPlay {
    name = 'mista_pays_the_larger_bonus_for_a_four_of_a_kind_of_4s',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S', '4H', '4C', '4D' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((60 + 16 + extra.fours_hand_chips) * (7 + extra.fours_hand_mult), "Mista did not pay the 4s Four of a Kind bonus alone")
    end
}
Balatest.TestPlay {
    name = 'mista_four_of_a_kind_of_4s_outscores_any_other_four_of_a_kind',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S', '4H', '4C', '4D' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        local aces_score = (60 + 44 + extra.hand_chips) * (7 + extra.hand_mult)
        Balatest.assert(G.GAME.chips > aces_score, "Four 4s scored no more than four Aces would with Mista")
    end
}
Balatest.TestPlay {
    name = 'mista_pays_every_4_before_debuffing',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S', '4H', '9C', '9D' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((20 + 26 + 2 * extra.card_chips) * (2 + 2 * extra.card_mult), "Mista debuffed before paying out every scored 4")
    end
}
Balatest.TestPlay {
    name = 'mista_debuffs_after_a_scored_4',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].debuff, "Mista was not debuffed after a 4 scored")
    end
}
Balatest.TestPlay {
    name = 'mista_debuffs_after_four_of_a_kind',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        keep_blind_unbeaten()
        Balatest.play_hand { '9S', '9H', '9C', '9D' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].debuff, "Mista was not debuffed after Four of a Kind")
    end
}
Balatest.TestPlay {
    name = 'mista_stays_active_without_a_4_or_four_of_a_kind',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '5S', '5H' }
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].debuff, "Mista was debuffed without a 4 or Four of a Kind")
        Balatest.assert_chips((10 + 10) * 2, "Mista paid out without a 4 or Four of a Kind")
    end
}
Balatest.TestPlay {
    name = 'mista_gives_nothing_while_debuffed',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S' }
        Balatest.play_hand { '4H' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((5 + 4 + extra.card_chips) * (1 + extra.card_mult) + (5 + 4), "Debuffed Mista still paid out")
    end
}
Balatest.TestPlay {
    name = 'mista_recovers_at_end_of_round',
    category = { 'jokers', 'golden_wind', 'mista' },
    jokers = { 'j_jojoker_mista' },
    execute = function()
        Balatest.play_hand { '4S' }
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].debuff, "Mista stayed debuffed after the round ended")
    end
}
--#endregion
