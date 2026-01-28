Balatest.TestPlay {
    name = 'smooth_operator_gains_0_mult_if_only_joker',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_smooth_operator' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Smooth Operator gained mult after round ended as sole joker.")
    end
}
Balatest.TestPlay {
    name = 'smooth_operator_gains_3_mult_if_3_jokers_and_not_moved',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_soft_and_wet', 'j_jojoker_smooth_operator', 'j_jojoker_soft_and_wet' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 3, "Smooth Operator did not gain mult for each held joker.")
    end
}
Balatest.TestPlay {
    name = 'smooth_operator_does_not_gain_mult_if_moved',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_soft_and_wet', 'j_jojoker_smooth_operator', },
    execute = function()
        G.jokers.cards[2].ability.extra.manually_repositioned = true
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.extra.mult, 0, "Smooth Operator gained mult but shouldn't have, due to being moved.")
    end
}
Balatest.TestPlay {
    name = 'smooth_operator_moves_on_blind_start',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_soft_and_wet', 'j_jojoker_smooth_operator', },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.position, 1, "Smooth Operator did not move on blind start.")
    end
}