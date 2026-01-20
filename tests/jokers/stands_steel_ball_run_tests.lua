--#region Mandom
Balatest.TestPlay {
    name = 'mandom_retriggers_only_first_6_scored_cards',
    category = { 'jokers', 'steel_ball_run', 'mandom' },
    blind = 'bl_wheel',
    jokers = { 'j_jojoker_mandom' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2D', '2H' }
        Balatest.play_hand { '3S', '3C', '3D', '3H' }
    end,
    assert = function()
        Balatest.assert_chips(1078, "Mandom didn't retrigger cards and score the expected amount")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.cards, 0, "Mandom had retriggers remaining")
    end
}
--#endregion