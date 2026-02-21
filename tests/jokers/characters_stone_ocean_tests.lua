--#region Green Baby
Balatest.TestPlay {
    name = 'green_baby_doubles_high_card_chips',
    category = { 'jokers', 'stone_ocean', 'green_baby' },
    jokers = { 'j_jojoker_green_baby' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(18, "Green Baby didn't double chips on scored High Card hand.")
    end
}
Balatest.TestPlay {
    name = 'green_baby_does_not_double_chips_on_non_high_card_hand',
    category = { 'jokers', 'stone_ocean', 'green_baby' },
    jokers = { 'j_jojoker_green_baby' },
    execute = function()
        Balatest.play_hand { '9S', '9D' }
    end,
    assert = function()
        Balatest.assert_chips(56, "Green Baby doubled chips on non-High Card hand.")
    end
}
--#endregion
