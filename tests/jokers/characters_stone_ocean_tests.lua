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
--#region Pucci
Balatest.TestPlay {
    name = 'pucci_retriggers_on_prime_rank',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Pucci did not retrigger on prime rank.")
    end
}
Balatest.TestPlay {
    name = 'pucci_does_not_retrigger_on_non_prime_rank',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Pucci retriggered on non-prime rank.")
    end
}
Balatest.TestPlay {
    name = 'pucci_only_retriggers_scored_cards',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '2D', '3S', '3H' }
    end,
    assert = function()
        Balatest.assert_chips(44, "Pucci retriggered on prime ranks that did not score.")
    end
}
--#endregion
