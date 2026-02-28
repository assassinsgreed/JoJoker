--#region Savage Garden
Balatest.TestPlay {
    name = 'savage_garden_does_not_give_xmult_on_hand_that_is_not_final',
    category = { 'jokers', 'stone_ocean', 'savage_garden' },
    jokers = { 'j_jojoker_savage_garden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Savage Garden gave Xmult on hand that is not final.")
    end
}
-- Balatest cannot test final hand functionality properly
--#endregion
