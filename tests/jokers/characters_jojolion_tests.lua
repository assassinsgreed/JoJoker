--#region Josuke Higashikata
Balatest.TestPlay {
    name = 'joskuke_higashikata_jjl_gives_chips_for_two_pair',
    category = { 'jokers', 'jojolion', 'josuke_higashikata_jjl' },
    jokers = { 'j_jojoker_josuke_higashikata_jjl' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '3H', '3D' }
    end,
    assert = function()
        Balatest.assert_chips(220, "Josuke Higashikata did not give chips for scored Two Pair")
    end
}

Balatest.TestPlay {
    name = 'joskuke_higashikata_jjl_gives_chips_for_full_house',
    category = { 'jokers', 'jojolion', 'josuke_higashikata_jjl' },
    jokers = { 'j_jojoker_josuke_higashikata_jjl' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '3H', '3D', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(532, "Josuke Higashikata did not give chips for scored Full House (containing two pair)")
    end
}
--#endregion
