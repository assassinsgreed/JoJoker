--#region Danny
Balatest.TestPlay {
    name = 'danny_gives_mult_when_played',
    category = { 'jokers', 'phantom_blood', 'danny' },
    jokers = { 'j_jojoker_danny' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * G.jokers.cards[1].ability.extra.mult, "Danny didn't give expected mult for hand")
    end
}
Balatest.TestPlay {
    name = 'danny_not_destroyed_when_score_not_on_fire',
    category = { 'jokers', 'phantom_blood', 'danny' },
    jokers = { 'j_jojoker_danny' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'danny_destroyed_when_score_on_fire',
    category = { 'jokers', 'phantom_blood', 'danny' },
    jokers = { 'j_jojoker_danny' },
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0)
    end
}
--#endregion
--#region Baron Zeppeli
Balatest.TestPlay {
    name = 'baron_zeppeli_cuts_chips_by_50_percent_and_increases_mult_by_20_percent_of_original_chips',
    category = { 'jokers', 'phantom_blood', 'baron_zeppeli' },
    jokers = { 'j_jojoker_baron_zeppeli' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(1920, "Baron Zeppeli didn't cut chips in half")
    end
}
--#endregion
--#region Speedwagon
Balatest.TestPlay {
    name = 'speedwagon_gives_no_money_when_no_discards_used',
    category = { 'jokers', 'phantom_blood', 'speedwagon' },
    jokers = { 'j_jojoker_speedwagon' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Speedwagon gave money when discards were not used")
    end
}
Balatest.TestPlay {
    name = 'speedwagon_gives_money_when_discard_is_used',
    category = { 'jokers', 'phantom_blood', 'speedwagon' },
    jokers = { 'j_jojoker_speedwagon' },
    execute = function()
        Balatest.discard { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_mod, "Speedwagon did not give money when discard was used")
    end
}
Balatest.TestPlay {
    name = 'speedwagon_gives_money_regardless_of_number_of_discarded_cards',
    category = { 'jokers', 'phantom_blood', 'speedwagon' },
    jokers = { 'j_jojoker_speedwagon' },
    execute = function()
        Balatest.discard { '2S', '3S' }
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_mod, "Speedwagon did not give money when discard was used")
    end
}
--#endregion
--#region Zombies
Balatest.TestPlay {
    name = 'zombies_gives_mult_for_each_held_Zombies_joker',
    category = { 'jokers', 'phantom_blood', 'zombies' },
    jokers = { 'j_jojoker_zombies', 'j_jojoker_zombies', 'j_jojoker_zombies' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local zombie_mult = G.jokers.cards[1].ability.extra.current_mult
        Balatest.assert_eq(zombie_mult, G.jokers.cards[1].ability.extra.mult_per ^ #G.jokers.cards, "Zombies did not give correct mult for held Zombies jokers")
    end
}

Balatest.TestPlay {
    name = 'zombies_replicate_at_end_of_round',
    category = { 'jokers', 'phantom_blood', 'zombies' },
    jokers = { 'j_jojoker_zombies' },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Zombies did not replicate at the end of the round")
    end
}
--#endregion
--#region Straizo
Balatest.TestPlay {
    name = 'straizo_gives_chips_for_straights',
    category = { 'jokers', 'phantom_blood', 'straizo' },
    jokers = { 'j_jojoker_straizo' },
    execute = function()
        Balatest.play_hand { '2S', '3H', '4D', '5C', '6S' }
    end,
    assert = function()
        local expected_chips = (50 + G.jokers.cards[1].ability.extra.chips_straight) * 4
        Balatest.assert_chips(expected_chips, "Straizo did not give correct chips for straights")
    end
}

Balatest.TestPlay {
    name = 'straizo_gives_chips_for_straight_flushes',
    category = { 'jokers', 'phantom_blood', 'straizo' },
    jokers = { 'j_jojoker_straizo' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        local expected_chips = (120 + G.jokers.cards[1].ability.extra.chips_straight_flush) * 8
        Balatest.assert_chips(expected_chips, "Straizo did not give correct chips for straight flushes")
    end
}

Balatest.TestPlay {
    name = 'straizo_gives_chips_for_royal_flushes',
    category = { 'jokers', 'phantom_blood', 'straizo' },
    jokers = { 'j_jojoker_straizo' },
    execute = function()
        Balatest.play_hand { '10S', 'JS', 'QS', 'KS', 'AS' }
    end,
    assert = function()
        local expected_chips = (151 + G.jokers.cards[1].ability.extra.chips_straight_flush) * 8
        Balatest.assert_chips(expected_chips, "Straizo did not give correct chips for royal flushes")
    end
}
--#endregion
--#region George Joestar
Balatest.TestPlay {
    name = 'george_joestar_gives_money_for_each_held_joker_at_end_of_round',
    category = { 'jokers', 'phantom_blood', 'george_joestar' },
    jokers = { 'j_jojoker_george_joestar', 'j_jojoker_speedwagon', 'j_jojoker_speedwagon' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_dollars(#G.jokers.cards * G.jokers.cards[1].ability.extra.money_mod, "George Joestar did not give correct money for each held joker")
    end
}
--#endregion