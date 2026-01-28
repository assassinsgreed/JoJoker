--#region N'Doul
Balatest.TestPlay {
    name = 'ndoul_sees_hearts_and_diamonds_as_same_suit',
    category = { 'jokers', 'stardust_crusaders', 'ndoul' },
    jokers = { 'j_jojoker_ndoul' },
    execute = function()
        Balatest.play_hand { '2H', '3D', '4H', '5D', '6H' }
    end,
    assert = function()
        local straight_flushes_played = G.GAME.hands["Straight Flush"].played_this_round
        Balatest.assert_eq(straight_flushes_played, 1, "N'Doul did not see hearts and diamonds as the same suit, resulting in a straight flush")
    end
}
Balatest.TestPlay {
    name = 'ndoul_sees_spades_and_clubs_as_same_suit',
    category = { 'jokers', 'stardust_crusaders', 'ndoul' },
    jokers = { 'j_jojoker_ndoul' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4S', '5C', '6S' }
    end,
    assert = function()
        local straight_flushes_played = G.GAME.hands["Straight Flush"].played_this_round
        Balatest.assert_eq(straight_flushes_played, 1, "N'Doul did not see spades and clubs as the same suit, resulting in a straight flush")
    end
}
--#endregion