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