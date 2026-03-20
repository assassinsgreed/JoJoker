--#region Danny (SBR)
Balatest.TestPlay {
    name = 'danny_sbr_does_not_destroy_a_joker_if_it_is_the_only_one',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Danny SBR destroyed a joker when it was the only one")
    end
}

Balatest.TestPlay {
    name = 'danny_sbr_destroys_a_random_joker_that_is_not_itself_when_added',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    jokers = { 'j_jojoker_oh_lonesome_me' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Danny SBR did not destroy a single joker when it was added")
        Balatest.assert_eq(G.jokers.cards[1].ability.name, "danny_sbr", "Danny SBR destroyed itself when it was added")
    end
}

Balatest.TestPlay {
    name = 'danny_sbr_destroys_a_single_random_joker_when_there_are_multiple',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    jokers = { 'j_jojoker_oh_lonesome_me', 'j_jojoker_tattoo_you' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Danny SBR did not destroy a single random joker when there were multiple")
    end
}
--#endregion

--#region Slow Dancer
Balatest.TestPlay {
    name = 'slow_dancer_gives_mult_for_each_scored_card_greater_than_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 1 -- Simulate previous hand having 1 scored card
        Balatest.play_hand { '9S', '9D', '5D', '5S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 4, "Slow Dancer did not update previous hand scored cards correctly")
        Balatest.assert_chips(48 * (2 + G.jokers.cards[1].ability.extra.mult * 3), "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
Balatest.TestPlay {
    name = 'slow_dancer_does_not_give_mult_for_same_number_of_scored_cards_as_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 1 -- Simulate previous hand having 1 scored card
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 1, "Slow Dancer updated previous hand scored cards when it shouldn't have")
        Balatest.assert_chips(7, "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
Balatest.TestPlay {
    name = 'slow_dancer_does_not_give_mult_for_fewer_scored_cards_than_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 3 -- Simulate previous hand having 3 scored cards
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 1, "Slow Dancer did not updated previous hand scored cards")
        Balatest.assert_chips(7, "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
--#endregion