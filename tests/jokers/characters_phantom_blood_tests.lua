--#region Danny
Balatest.TestPlay {
    name = 'danny_gives_mult_when_played',
    category = { 'jokers', 'phantom_blood', 'danny' },
    jokers = { 'j_jojoker_danny' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "Danny didn't give expected mult for hand")
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
    name = 'zombies_gives_mult_for_each_held_zombies_joker',
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
--#region Dario Brando
Balatest.TestPlay {
    name = 'dario_brando_steals_money_for_each_hand_played',
    category = { 'jokers', 'phantom_blood', 'dario_brando' },
    jokers = { 'j_jojoker_dario_brando' },
    dollars = 10,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(10 - G.jokers.cards[1].ability.extra.money_mod, "Dario Brando did not steal correct money for each hand played")
    end
}

Balatest.TestPlay {
    name = 'dario_brando_multiplies_sell_value_at_end_of_round',
    category = { 'jokers', 'phantom_blood', 'dario_brando' },
    jokers = { 'j_jojoker_dario_brando' },
    dollars = 10,
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 0
        G.jokers.cards[1].ability.extra_value = 10
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra_value, 10 * G.jokers.cards[1].ability.extra.sell_value_mult, "Dario Brando did not multiply sell value correctly at the end of the round")
    end
}

Balatest.TestPlay {
    name = 'dario_brando_destroys_himself_at_end_of_round',
    category = { 'jokers', 'phantom_blood', 'dario_brando' },
    jokers = { 'j_jojoker_dario_brando' },
    dollars = 10,
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = G.jokers.cards[1].ability.extra.denominator
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0, "Dario Brando did not destroy himself at the end of the round")
    end
}
--#endregion
--#region Erina
Balatest.TestPlay {
    name = 'erina_gives_mult_for_herself',
    category = { 'jokers', 'phantom_blood', 'erina' },
    jokers = { 'j_jojoker_erina' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (1 + G.jokers.cards[1].ability.extra.mult_mod * 1), "Erina did not give mult for herself.")
    end
}
Balatest.TestPlay {
    name = 'erina_gives_mult_for_each_character_joker',
    category = { 'jokers', 'phantom_blood', 'erina' },
    jokers = { 'j_jojoker_erina', 'j_jojoker_speedwagon', 'j_jojoker_straizo' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (1 + G.jokers.cards[1].ability.extra.mult_mod * 3), "Erina did not give mult for each character joker.")
    end
}
--#endregion
--#region Jonathan Joestar
Balatest.TestPlay {
    name = 'jonathan_joestar_gives_chips_for_each_unique_suit_in_scored_hand',
    category = { 'jokers', 'phantom_blood', 'jonathan_joestar' },
    jokers = { 'j_jojoker_jonathan_joestar' },
    execute = function()
        Balatest.play_hand { '2S', '2D' }
    end,
    assert = function()
        Balatest.assert_chips(228, "Jonathan Joestar did not give correct chips for each unique suit in scored hand")
    end
}

Balatest.TestPlay {
    name = 'jonathan_joestar_does_not_give_chips_for_unscored_cards',
    category = { 'jokers', 'phantom_blood', 'jonathan_joestar' },
    jokers = { 'j_jojoker_jonathan_joestar' },
    execute = function()
        Balatest.play_hand { '2S', '3D' }
    end,
    assert = function()
        Balatest.assert_chips(58, "Jonathan Joestar gave chips for unscored cards")
    end
}

Balatest.TestPlay {
    name = 'jonathan_joestar_gives_chips_for_wild_cards_in_scored_hand',
    category = { 'jokers', 'phantom_blood', 'jonathan_joestar' },
    jokers = { 'j_jojoker_jonathan_joestar' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_wild' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(57, "Jonathan Joestar did not give correct chips for wild card")
    end
}

Balatest.TestPlay {
    name = 'jonathan_joestar_caps_chips_when_many_unique_suits_in_scored_hand',
    category = { 'jokers', 'phantom_blood', 'jonathan_joestar' },
    jokers = { 'j_jojoker_jonathan_joestar' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_wild' },
        { r = '2', s = 'C' },
        { r = '2', s = 'D' },
        { r = '2', s = 'H' },
        { r = '2', s = 'S' } } },
    execute = function()
        Balatest.play_hand { '2S', '2S', '2C', '2D', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(3960, "Jonathan Joestar did not cap chips based on 5 unique suits (given wild cards)")
    end
}
--#endregion