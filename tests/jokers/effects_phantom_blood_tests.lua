--#region Sword of Luck and Pluck
-- We cannot reliably test the chance of lucky cards occurring
--#endregion

--#region Thunder Cross Split Attack
Balatest.TestPlay {
    name = 'thunder_cross_split_attack_removes_money_and_increases_xmult_when_playing_a_card',
    category = { 'jokers', 'phantom_blood', 'thunder_cross_split_attack' },
    jokers = { 'j_jojoker_thunder_cross_split_attack' },
    execute = function()
        G.GAME.dollars = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(1, "Thunder Cross Split Attack did not remove the expected money when a card was played")
        Balatest.assert_eq(1.2, G.jokers.cards[1].ability.extra.Xmult, "Thunder Cross Split Attack did not increase Xmult when money was removed")
    end
}

Balatest.TestPlay {
    name = 'thunder_cross_split_attack_only_procs_on_scored_cards',
    category = { 'jokers', 'phantom_blood', 'thunder_cross_split_attack' },
    jokers = { 'j_jojoker_thunder_cross_split_attack' },
    execute = function()
        G.GAME.dollars = 10
        Balatest.play_hand { '2S', '2C', '3C' }
    end,
    assert = function()
        Balatest.assert_dollars(8, "Thunder Cross Split Attack did not remove the expected money when a card was played")
        Balatest.assert_eq(1.4, G.jokers.cards[1].ability.extra.Xmult, "Thunder Cross Split Attack did not increase Xmult when money was removed")
    end
}

--#endregion