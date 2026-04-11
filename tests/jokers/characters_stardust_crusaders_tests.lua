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
--#region Old Joseph Joestar
Balatest.TestPlay {
    name = 'old_joseph_joestar_gains_xmult_on_discard',
    category = { 'jokers', 'stardust_crusaders', 'old_joseph_joestar' },
    jokers = { 'j_jojoker_old_joseph_joestar' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.discard { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + G.jokers.cards[1].ability.extra.Xmult_mod, "Old Joseph Joestar did not gain Xmult on discard while quipping")
    end
}
--#endregion
--#region Hol Horse
Balatest.TestPlay {
    name = 'hol_horse_gives_no_mult_when_pair_not_played',
    category = { 'jokers', 'stardust_crusaders', 'hol_horse' },
    jokers = { 'j_jojoker_hol_horse' },
    execute = function()
        Balatest.play_hand { '2S', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(8, "Hol Horse gave extra mult when a pair was not played")
    end
}

Balatest.TestPlay {
    name = 'hol_horse_gives_mult_based_on_unscored_cards_ranks',
    category = { 'jokers', 'stardust_crusaders', 'hol_horse' },
    jokers = { 'j_jojoker_hol_horse' },
    execute = function()
        Balatest.play_hand { '2S', '2C', 'AS', 'QS', 'JS' } -- Pair, leaving 37 unscored ranks (14 + 12 + 11)
    end,
    assert = function()
        -- 2 from mult, 37 from unscored
        Balatest.assert_chips(14 * (2 + 37), "Hol Horse did not give mult based on unscored cards ranks")
    end
}
--#endregion
--#region D'Arby Brothers
Balatest.TestPlay {
    name = 'darby_brothers_doubles_probabilities',
    category = { 'jokers', 'stardust_crusaders', 'darby_brothers', 'old_joseph_joestar' },
    jokers = { 'j_jojoker_darby_brothers', 'j_jojoker_old_joseph_joestar' },
    execute = function()
        -- Just in case Josephs's values change someday
        G.jokers.cards[2].ability.extra.numerator = 1
        G.jokers.cards[2].ability.extra.denominator = 2

        -- Triggering 8 back-to-back procs would be extremely unlikely without D'Arby Brothers doubling priorities
        Balatest.discard { '2S' }
        Balatest.discard { '2C' }
        Balatest.discard { '2D' }
        Balatest.discard { '2H' }
        Balatest.discard { '3S' }
        Balatest.discard { '3C' }
        Balatest.discard { '3D' }
        Balatest.discard { '3H' }
        Balatest.play_hand { '4C' }
    end,
    assert = function()
        -- Accumulating the xmult leads to some float imprecision; we just check the chip count of scoring a 4 because I don't care
        Balatest.assert_chips(19, "Darby Brothers did not double the probability of Old Joseph's ability")
    end
}
--#endregion