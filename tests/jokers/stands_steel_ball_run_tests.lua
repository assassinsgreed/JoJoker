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

Balatest.TestPlay {
    name = 'chocolate_disco_treats_aces_as_odd',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        -- High card Ace on odd ante: (5 base + 11 ace + 25 from Chocolate Disco) * 1 mult
        Balatest.assert_chips(41, "Chocolate Disco did not give chips for an Ace on an odd ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_treat_aces_as_even',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        G.GAME.round_resets.blind_ante = 2
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        -- High card Ace on even ante: (5 base + 11 ace) * 1 mult, no bonus
        Balatest.assert_chips(16, "Chocolate Disco gave mult for an Ace on an even ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_count_face_cards_as_odd',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        -- High card King on odd ante: (5 base + 10 king) * 1 mult, no bonus
        Balatest.assert_chips(15, "Chocolate Disco gave chips for a King on an odd ante")
    end
}

Balatest.TestPlay {
    name = 'chocolate_disco_does_not_count_face_cards_as_even',
    category = { 'jokers', 'steel_ball_run', 'chocolate_disco' },
    jokers = { 'j_jojoker_chocolate_disco' },
    execute = function()
        G.GAME.round_resets.blind_ante = 2
        Balatest.play_hand { 'QS' }
    end,
    assert = function()
        -- High card Queen on even ante: (5 base + 10 queen) * 1 mult, no bonus
        Balatest.assert_chips(15, "Chocolate Disco gave mult for a Queen on an even ante")
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
        -- Use SMODS.debuff_card so the remove_from_deck(from_debuff) hook actually fires
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'balatest')
            return true
        end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].debuff, true, "Oh Lonesome Me was not debuffed during the test")
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

--#region Civil War
-- Can't skip boosters with Civil War so we just validate chip gain in match
Balatest.TestPlay {
    name = 'civil_war_gives_extra_chips_after_skipping_booster_pack',
    category = { 'jokers', 'steel_ball_run', 'civil_war' },
    jokers = { 'j_jojoker_civil_war' },
    execute = function()
        G.jokers.cards[1].ability.extra.chips = 20
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(27, "Civil War did not give extra chips after skipping booster pack")
    end
}
--#endregion

--#region Ball Breaker
Balatest.TestPlay {
    name = 'ball_breaker_gives_mult_for_fibonnaci_numbers',
    category = { 'jokers', 'steel_ball_run', 'ball_breaker' },
    jokers = { 'j_jojoker_ball_breaker' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (1 + G.jokers.cards[1].ability.extra.mult), "Ball Breaker did not give mult for Fibonacci number")
    end
}

Balatest.TestPlay {
    name = 'ball_breaker_does_not_give_mult_for_non_fibonnaci_numbers',
    category = { 'jokers', 'steel_ball_run', 'ball_breaker' },
    jokers = { 'j_jojoker_ball_breaker' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Ball Breaker gave mult for non-Fibonacci number")
    end
}
--#endregion

--#region Love Train
Balatest.TestPlay {
    name = 'love_train_prevents_glass_cards_from_shattering',
    category = { 'jokers', 'steel_ball_run', 'love_train' },
    jokers = { 'j_jojoker_love_train' },
    deck = { cards = {
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', 'AS', 'AS', 'AS' } -- Would be crazy for all to not shatter if this wasn't working
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 5, "Love Train did not prevent glass card from shattering")
    end
}
--#endregion

--#region In a Silent Way
Balatest.TestPlay {
    name = 'in_a_silent_way_gains_mult_when_booster_opened',
    category = { 'jokers', 'steel_ball_run', 'in_a_silent_way' },
    jokers = { 'j_jojoker_in_a_silent_way' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.open(function() return G.shop_booster.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.current_mult, G.jokers.cards[1].ability.extra.mult_mod, "In a Silent Way did not gain mult for opened booster pack")
    end
}
--#endregion