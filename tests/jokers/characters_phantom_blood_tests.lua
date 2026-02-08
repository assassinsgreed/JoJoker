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
    name = 'baron_zeppeli_cuts_chips_by_50_percent_and_increases_mult_by_15_percent_of_original_chips',
    category = { 'jokers', 'phantom_blood', 'baron_zeppeli' },
    jokers = { 'j_jojoker_baron_zeppeli' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(1200, "Baron Zeppeli didn't cut chips in half")
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
        Balatest.highlight { '2S' } -- Needed to complete execute block
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