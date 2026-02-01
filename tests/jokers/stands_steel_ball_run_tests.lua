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
--#region Chocolate Disco
Balatest.TestPlay {
    name = 'chocolate_disco_does_not_trigger_mult_for_even_card_on_odd_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Chocolate Disco triggered mult on odd ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_trigger_chips_when_even_cards_played_on_odd_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Chocolate Disco added chips when playing even card on odd ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_adds_chips_when_playing_odd_cards_on_odd_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        Balatest.play_hand { '3S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(132, "Chocolate Disco did not add chips when playing odd cards on odd ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_trigger_chips_for_odd_card_on_even_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        G.GAME.round_resets.blind_ante = 2
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(8, "Chocolate Disco triggered chips on even ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_trigger_mult_when_odd_cards_played_on_even_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        G.GAME.round_resets.blind_ante = 2
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(8, "Chocolate Disco added mult when playing odd card on even ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_adds_mult_when_playing_even_cards_on_even_ante',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        G.GAME.round_resets.blind_ante = 2
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(168, "Chocolate Disco did not add mult when playing even cards on even ante")
    end
}
--#endregion