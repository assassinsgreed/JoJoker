--#region Danny (SBR)
Balatest.TestPlay {
    name = 'danny_sbr_does_not_destroy_a_joker_if_it_is_the_only_one',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Danny SBR destroyed a joker when it was the only one")
    end
}

Balatest.TestPlay {
    name = 'danny_sbr_destroys_a_random_joker_that_is_not_itself_when_added',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    jokers = { 'j_jojoker_oh_lonesome_me' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Danny SBR did not destroy a single joker when it was added")
        Balatest.assert_eq(G.jokers.cards[1].ability.name, "danny_sbr", "Danny SBR destroyed itself when it was added")
    end
}

Balatest.TestPlay {
    name = 'danny_sbr_destroys_a_single_random_joker_when_there_are_multiple',
    category = { 'jokers', 'steel_ball_run', 'danny_sbr' },
    jokers = { 'j_jojoker_oh_lonesome_me', 'j_jojoker_tattoo_you' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1]) -- Trigger Danny to be added via registered hook
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Danny SBR did not destroy a single random joker when there were multiple")
    end
}
--#endregion

--#region Slow Dancer
Balatest.TestPlay {
    name = 'slow_dancer_gives_mult_for_each_scored_card_greater_than_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 1 -- Simulate previous hand having 1 scored card
        Balatest.play_hand { '9S', '9D', '5D', '5S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 4, "Slow Dancer did not update previous hand scored cards correctly")
        Balatest.assert_chips(48 * (2 + G.jokers.cards[1].ability.extra.mult * 3), "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
Balatest.TestPlay {
    name = 'slow_dancer_does_not_give_mult_for_same_number_of_scored_cards_as_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 1 -- Simulate previous hand having 1 scored card
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 1, "Slow Dancer updated previous hand scored cards when it shouldn't have")
        Balatest.assert_chips(7, "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
Balatest.TestPlay {
    name = 'slow_dancer_does_not_give_mult_for_fewer_scored_cards_than_previous_hand',
    category = { 'jokers', 'steel_ball_run', 'slow_dancer' },
    jokers = { 'j_jojoker_slow_dancer' },
    execute = function()
        G.jokers.cards[1].ability.extra.previous_hand = 3 -- Simulate previous hand having 3 scored cards
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local previous_hand = G.jokers.cards[1].ability.extra.previous_hand
        Balatest.assert_eq(previous_hand, 1, "Slow Dancer did not updated previous hand scored cards")
        Balatest.assert_chips(7, "Slow Dancer did not give the correct multiplier for scored cards greater than previous hand")
    end
}
--#endregion
--#region Valkyrie
Balatest.TestPlay {
    name = 'Valkyrie_counts_down_only_scored_cards',
    category = { 'jokers', 'steel_ball_run', 'valkyrie' },
    jokers = { 'j_jojoker_valkyrie' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '4D' }
    end,
    assert = function()
        local scored_cards_remaining = G.jokers.cards[1].ability.extra.scored_cards_remaining
        Balatest.assert_eq(scored_cards_remaining, G.jokers.cards[1].ability.extra.card_threshold - 2, "Valkyrie did not count down only scored cards")
    end
}

Balatest.TestPlay {
    name = 'Valkyrie_resets_scored_card_count_when_reached',
    category = { 'jokers', 'steel_ball_run', 'valkyrie' },
    jokers = { 'j_jojoker_valkyrie' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 2
        Balatest.play_hand { '2S', '2C', '4D' }
    end,
    assert = function()
        local scored_cards_remaining = G.jokers.cards[1].ability.extra.scored_cards_remaining
        Balatest.assert_eq(scored_cards_remaining, G.jokers.cards[1].ability.extra.card_threshold, "Valkyrie did not reset scored card count when reached")
    end
}

Balatest.TestPlay {
    name = 'Valkyrie_overflows_scored_cards_when_remaining_amount_is_surpassed',
    category = { 'jokers', 'steel_ball_run', 'valkyrie' },
    jokers = { 'j_jojoker_valkyrie' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 1
        Balatest.play_hand { '2S', '2C', '4D' }
    end,
    assert = function()
        local scored_cards_remaining = G.jokers.cards[1].ability.extra.scored_cards_remaining
        Balatest.assert_eq(scored_cards_remaining, G.jokers.cards[1].ability.extra.card_threshold - 1, "Valkyrie did not reset scored card count when overflowed")
    end
}

Balatest.TestPlay {
    name = 'Valkyrie_gives_chips_for_each_card_remaining_in_deck_when_threshold_reached',
    category = { 'jokers', 'steel_ball_run', 'valkyrie' },
    jokers = { 'j_jojoker_valkyrie' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.chip_payout, "Valkyrie did not give chips for remaining cards in the deck")
    end
}
--#endregion

--#region Sugar Mountain
local function count_sugar_mountains()
    local count = 0
    for _, joker in ipairs(G.jokers.cards) do
        if joker.ability.name == 'sugar_mountain' then
            count = count + 1
        end
    end
    return count
end

Balatest.TestPlay {
    name = 'sugar_mountain_gives_money_on_shop_entry',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_given, "Sugar Mountain did not give money on shop entry")
    end
}

Balatest.TestPlay {
    name = 'sugar_mountain_sets_money_to_zero_if_overspending',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        G.jokers.cards[1].ability.extra.spend_left = 0 -- Simulate spending all given money
        Balatest.buy(function() return G.shop_jokers.cards[1] end) -- Buy anything; $10 is cap
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_dollars(0, "Sugar Mountain did not clear out cash when overspending")
        Balatest.assert_eq(count_sugar_mountains(), 0, "Sugar Mountain was not destroyed when overspending")
    end
}

Balatest.TestPlay {
    name = 'sugar_mountain_sets_money_to_zero_if_sold_in_shop',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        -- $4 from sell value
        Balatest.assert_dollars(4, "Sugar Mountain did not clear out cash when sold in shop")
    end
}

Balatest.TestPlay {
    name = 'sugar_mountain_does_not_set_money_to_zero_if_sold_outside_of_shop',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    dollars = 10,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(14, "Sugar Mountain did not retain cash when sold outside of shop")
    end
}

Balatest.TestPlay {
    name = 'sugar_mountain_sets_money_to_zero_if_threshold_not_hit_when_leaving_shop',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_dollars(0, "Sugar Mountain did not clear out cash when threshold not hit")
        Balatest.assert_eq(count_sugar_mountains(), 0, "Sugar Mountain was not destroyed when threshold not hit")
    end
}

Balatest.TestPlay {
    name = 'sugar_mountain_does_not_set_money_to_zero_if_threshold_hit_when_leaving_shop',
    category = { 'jokers', 'steel_ball_run', 'sugar_mountain' },
    jokers = { 'j_jojoker_sugar_mountain' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        G.jokers.cards[1].ability.extra.spend_left = 0 -- Simulate spending all given money
        Balatest.exit_shop()
    end,
    assert = function()
        -- $10 original + $20 from sugar mountain (due to how we test, this isn't spent)
        Balatest.assert_dollars(30, "Sugar Mountain did not retain cash when threshold hit")
        Balatest.assert_eq(count_sugar_mountains(), 1, "Sugar Mountain was destroyed even though the threshold was hit")
    end
}
--#endregion