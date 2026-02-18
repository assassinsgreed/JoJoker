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
--#region Oh Lonesome Me
Balatest.TestPlay {
    name = 'oh_lonesome_me_increases_hand_size',
    category = { 'jokers', 'steel_ball_run', 'oh_lonesome_me' },
    jokers = { 'j_jojoker_oh_lonesome_me' },
    hand_size = 8,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.hand.config.card_limit, 8 + G.jokers.cards[1].ability.extra.hand_size, "Oh Lonesome Me did not increase hand size correctly")
    end
}

Balatest.TestPlay {
    name = 'oh_lonesome_me_decreases_hand_size_when_sold',
    category = { 'jokers', 'steel_ball_run', 'oh_lonesome_me' },
    jokers = { 'j_jojoker_oh_lonesome_me' },
    hand_size = 8,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.hand.config.card_limit, 8, "Oh Lonesome Me did not decrease hand size correctly when sold")
    end
}

Balatest.TestPlay {
    name = 'oh_lonesome_me_does_not_decrease_hand_size_when_debuffed',
    category = { 'jokers', 'steel_ball_run', 'oh_lonesome_me' },
    jokers = { 'j_jojoker_oh_lonesome_me' },
    hand_size = 8,
    execute = function()
        G.jokers.cards[1].debuff = true
    end,
    assert = function()
        Balatest.assert_eq(G.hand.config.card_limit, 8 + G.jokers.cards[1].ability.extra.hand_size, "Oh Lonesome Me decreased hand size when debuffed, but should not have")
    end
}
--#endregion
--#region Hey Ya!
Balatest.TestPlay {
    name = 'hey_ya_converts_scored_cards_to_lucky',
    category = { 'jokers', 'steel_ball_run', 'hey_ya' },
    jokers = { 'j_jojoker_hey_ya' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        Balatest.assert_eq(G.deck.cards[1].config.center, G.P_CENTERS.m_lucky, "Hey Ya! didn't convert scored card to lucky edition")
    end
}

Balatest.TestPlay {
    name = 'hey_ya_converts_multiple_scored_cards_to_lucky',
    category = { 'jokers', 'steel_ball_run', 'hey_ya' },
    jokers = { 'j_jojoker_hey_ya' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        Balatest.play_hand { 'QS', 'QC' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        Balatest.assert_eq(G.deck.cards[1].config.center, G.P_CENTERS.m_lucky, "Hey Ya! didn't convert scored card to lucky edition")
        Balatest.assert_eq(G.deck.cards[2].config.center, G.P_CENTERS.m_lucky, "Hey Ya! didn't convert scored card to lucky edition")
    end
}

Balatest.TestPlay {
    name = 'hey_ya_does_not_convert_card_with_existing_center_to_lucky',
    category = { 'jokers', 'steel_ball_run', 'hey_ya' },
    jokers = { 'j_jojoker_hey_ya' },
    deck = { cards = {
        { r = 'Q', s = 'S', e = 'm_stone' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        Balatest.assert_eq(G.deck.cards[1].config.center, G.P_CENTERS.m_stone, "Hey Ya! converted scored stone card to lucky edition but should not have")
    end
}

Balatest.TestPlay {
    name = 'hey_ya_always_triggers_lucky_cards',
    category = { 'jokers', 'steel_ball_run', 'hey_ya' },
    jokers = { 'j_jojoker_hey_ya' },
    deck = { cards = {
        { r = 'Q', s = 'S', e = 'm_lucky' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'QS' }
    end,
    assert = function()
        Balatest.assert_chips(315, "Hey Ya! did not trigger mult bonus from lucky card")
    end
}
--#endregion

--#region TATTOO YOU!
Balatest.TestPlay {
    name = 'tattoo_you_converts_exactly_one_scored_non_jack_to_jack',
    category = { 'jokers', 'steel_ball_run', 'tattoo_you' },
    jokers = { 'j_jojoker_tattoo_you' },
    deck = { cards = {
        { r = '5', s = 'H' },
        { r = 'Q', s = 'S' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '5H', 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local jack_count = 0
        for _, v in pairs(G.deck.cards) do
            if v:get_id() == 11 then
                jack_count = jack_count + 1
            end
        end
        Balatest.assert_eq(jack_count, 1, "TATTOO YOU! did not convert exactly one scored non-Jack to Jack")
    end
}

Balatest.TestPlay {
    name = 'tattoo_you_does_not_convert_when_only_jacks_scored',
    category = { 'jokers', 'steel_ball_run', 'tattoo_you' },
    jokers = { 'j_jojoker_tattoo_you' },
    deck = { cards = {
        { r = 'J', s = 'S' },
        { r = 'J', s = 'C' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'JS', 'JC' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local jack_count = 0
        for _, v in pairs(G.deck.cards) do
            if v:get_id() == 11 then
                jack_count = jack_count + 1
            end
        end
        Balatest.assert_eq(jack_count, 2, "TATTOO YOU! converted cards when only Jacks were scored")
    end
}
--#endregion
