--#region Sex Pistols
Balatest.TestPlay {
    name = 'sex_pistols_no_mult_when_invalid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Sex Pistols mult wasn't 0 when no valid rank present")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_correctly_based_on_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7 and a 2")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_instance_of_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '7C' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing two 7s")
    end
}
--#endregion
--#region Grateful Dead
Balatest.TestPlay {
    name = 'grateful_dead_starts_with_correct_mult',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.starting_mult + 1), "Grateful Dead mult started decayed.")
    end
}
Balatest.TestPlay {
    name = 'grateful_dead_mult_decays_on_round_end',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local new_mult = G.jokers.cards[1].ability.extra.mult
        Balatest.assert_eq(new_mult, G.jokers.cards[1].ability.extra.starting_mult - G.jokers.cards[1].ability.extra.mult_decay, "Grateful Dead mult didn't decay at the end of the round.")
    end
}
Balatest.TestPlay {
    name = 'grateful_dead_mult_cannot_decay_below_zero',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        G.jokers.cards[1].ability.extra.mult = 0
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(0, G.jokers.cards[1].ability.extra.mult, "Grateful Dead mult decayed below zero.")
    end
}
--#endregion