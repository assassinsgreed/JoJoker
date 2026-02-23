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