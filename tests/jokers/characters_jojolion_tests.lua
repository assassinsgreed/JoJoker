--#region Josuke Higashikata
Balatest.TestPlay {
    name = 'joskuke_higashikata_jjl_applies_four_fingers',
    category = { 'jokers', 'jojolion', 'josuke_higashikata_jjl' },
    jokers = { 'j_jojoker_josuke_higashikata_jjl' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4H', '5D' }
    end,
    assert = function()
        local straights_played = G.GAME.hands["Straight"].played_this_round
        Balatest.assert_eq(straights_played, 1, "Josuke Higashikata did not apply four fingers and score a straight")
    end
}
--#endregion
