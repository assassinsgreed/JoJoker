--#region Sword of Luck and Pluck

-- We cannot reliably test the chance of lucky cards occurring

--#endregion

--#region Thunder Cross Split Attack

Balatest.TestPlay {
    name = 'thunder_cross_split_attack_removes_money_and_increases_xmult_when_playing_a_card',
    category = { 'jokers', 'phantom_blood', 'thunder_cross_split_attack' },
    jokers = { 'j_jojoker_thunder_cross_split_attack' },
    execute = function()
        G.GAME.dollars = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Thunder Cross Split Attack did not remove the expected money when a card was played")
        Balatest.assert_eq(1.2, G.jokers.cards[1].ability.extra.Xmult, "Thunder Cross Split Attack did not increase Xmult when money was removed")
    end
}

Balatest.TestPlay {
    name = 'thunder_cross_split_attack_only_procs_on_scored_cards',
    category = { 'jokers', 'phantom_blood', 'thunder_cross_split_attack' },
    jokers = { 'j_jojoker_thunder_cross_split_attack' },
    execute = function()
        G.GAME.dollars = 10
        Balatest.play_hand { '2S', '2C', '3C' }
    end,
    assert = function()
        Balatest.assert_dollars(6, "Thunder Cross Split Attack did not remove the expected money when a card was played")
        Balatest.assert_eq(1.4, G.jokers.cards[1].ability.extra.Xmult, "Thunder Cross Split Attack did not increase Xmult when money was removed")
    end
}

Balatest.TestPlay {
    name = 'thunder_cross_split_attack_does_not_proc_without_enough_money',
    category = { 'jokers', 'phantom_blood', 'thunder_cross_split_attack' },
    jokers = { 'j_jojoker_thunder_cross_split_attack' },
    execute = function()
        G.GAME.dollars = 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(1, "Thunder Cross Split Attack removed money when there was not enough to take")
        Balatest.assert_eq(1, G.jokers.cards[1].ability.extra.Xmult, "Thunder Cross Split Attack increased Xmult without taking money")
    end
}

--#endregion

--#region Roundabout

Balatest.TestPlay {
    name = 'roundabout_retriggers_scored_card_once_per_unscored_card',
    category = { 'jokers', 'phantom_blood', 'roundabout' },
    jokers = { 'j_jojoker_roundabout' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        -- High Card: 5 chips + 3 scored twice, x1 mult
        Balatest.assert_chips(11, "Roundabout did not retrigger the scored card once for the unscored card")
    end
}

Balatest.TestPlay {
    name = 'roundabout_retriggers_scored_card_for_each_of_four_unscored_cards',
    category = { 'jokers', 'phantom_blood', 'roundabout' },
    jokers = { 'j_jojoker_roundabout' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4D', '5H', '7C' }
    end,
    assert = function()
        -- High Card: 5 chips + 7 scored five times, x1 mult
        Balatest.assert_chips(40, "Roundabout did not retrigger the scored card once per unscored card")
    end
}

Balatest.TestPlay {
    name = 'roundabout_does_not_retrigger_when_every_card_scores',
    category = { 'jokers', 'phantom_blood', 'roundabout' },
    jokers = { 'j_jojoker_roundabout' },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        -- Pair: (10 chips + 2 + 2) x2 mult
        Balatest.assert_chips(28, "Roundabout retriggered with no unscored cards")
    end
}

Balatest.TestPlay {
    name = 'roundabout_does_not_retrigger_when_survivor_makes_every_card_score',
    category = { 'jokers', 'phantom_blood', 'roundabout' },
    jokers = { 'j_jojoker_survivor', 'j_jojoker_roundabout' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        -- High Card with Splash rules: 5 chips + 2 + 3, x1 mult
        Balatest.assert_chips(10, "Roundabout retriggered when Survivor made every played card score")
    end
}

--#endregion

--#region Vampiric Touch

Balatest.TestPlay {
    name = 'vampiric_touch_drains_money_from_each_joker_at_end_of_blinds',
    category = { 'jokers', 'phantom_blood', 'vampiric_touch' },
    jokers = { 'j_jojoker_jonathan_joestar', 'j_jojoker_danny', 'j_jojoker_vampiric_touch' },
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(4, G.jokers.cards[3].sell_cost, "Vampiric Touch did not drain money from the other jokers") -- has $2 sell value initially
    end
}

Balatest.TestPlay {
    name = 'vampiric_touch_does_not_drain_sell_value_from_jokers_with_no_sell_value',
    category = { 'jokers', 'phantom_blood', 'vampiric_touch' },
    jokers = { 'j_jojoker_jonathan_joestar', 'j_jojoker_vampiric_touch' },
    execute = function()
        G.jokers.cards[1].sell_cost = 0 -- Ensure the first joker has no sell value
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(0, G.jokers.cards[1].sell_cost, "Vampiric Touch drained money from joker without sell value")
        Balatest.assert_eq(2, G.jokers.cards[2].sell_cost, "Vampiric Touch' sell value increased when it did not drain") -- has $2 sell value initially
    end
}

--#endregion

--#region Hamon
Balatest.TestPlay {
    name = 'hamon_converts_all_discards_into_hands_when_blind_is_selected',
    category = { 'jokers', 'phantom_blood', 'hamon' },
    jokers = { 'j_jojoker_hamon' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 7, "Hamon did not convert discards into hands")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 0, "Hamon did not remove the converted discards")
    end
}

Balatest.TestPlay {
    name = 'hamon_does_not_change_per_round_hands_or_discards',
    category = { 'jokers', 'phantom_blood', 'hamon' },
    jokers = { 'j_jojoker_hamon' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.round_resets.hands, 4, "Hamon changed the per-round hand total")
        Balatest.assert_eq(G.GAME.round_resets.discards, 3, "Hamon changed the per-round discard total")
    end
}

Balatest.TestPlay {
    name = 'hamon_converts_discards_again_on_the_next_blind',
    category = { 'jokers', 'phantom_blood', 'hamon' },
    jokers = { 'j_jojoker_hamon' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 7, "Hamon did not convert discards on the next blind")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 0, "Hamon left discards on the next blind")
    end
}

Balatest.TestPlay {
    name = 'hamon_does_nothing_with_no_discards',
    category = { 'jokers', 'phantom_blood', 'hamon' },
    jokers = { 'j_jojoker_hamon' },
    hands = 4,
    discards = 0,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 4, "Hamon changed hands with no discards to convert")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 0, "Hamon changed discards when there were none")
    end
}

Balatest.TestPlay {
    name = 'hamon_stops_converting_once_sold',
    category = { 'jokers', 'phantom_blood', 'hamon' },
    jokers = { 'j_jojoker_hamon' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 4, "Hamon still added hands after being sold")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 3, "Hamon still removed discards after being sold")
    end
}
--#endregion
