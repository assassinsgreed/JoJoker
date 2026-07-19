--#region Smooth Operator
-- (The pre-scoring shuffle cannot be tested with Balatest, but a single-card
-- hand skips the shuffle entirely, letting us test the chip payout)
Balatest.TestPlay {
    name = 'smooth_operator_gives_chips_for_each_scored_card',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_smooth_operator' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        -- High card 2: (5 base + 2 rank + 20 from Smooth Operators) * 1 mult
        Balatest.assert_chips(27, "Smooth Operators did not add chips for scored cards")
    end
}
--#endregion
