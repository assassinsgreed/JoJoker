--#region The Fifth Lesson
Balatest.TestPlay {
    name = 'the_fifth_lesson_shortcut_applies',
    category = { 'jokers', 'steel_ball_run', 'the_fifth_lesson' },
    jokers = { 'j_jojoker_the_fifth_lesson' },
    execute = function()
        Balatest.play_hand { 'AS', 'KC', 'QD', '10H', '9S' } -- Straight with missing Jack
    end,
    assert = function()
        Balatest.assert_chips(320, "The Fifth Lesson didn't play a straight")
    end
}
--#endregion
--#region Turbo Eyes
Balatest.TestPlay {
    name = 'turbo_eyes_adds_top_two_cards_chips_to_score',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being dealt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card + 2 4s
        Balatest.assert_chips(9 + 4 * 2, "Turbo Eyes did not give correct chips based on top 2 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_adds_fewer_than_two_cards_chips_to_score_when_deck_has_fewer_than_two_cards',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being dealt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card + 1 4s
        Balatest.assert_chips(9 + 4 * 1, "Turbo Eyes did not give correct chips based on up to top 2 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_adds_no_additional_chips_when_deck_is_empty',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being dealt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In hand
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card
        Balatest.assert_chips(9 + 4 * 0, "Turbo Eyes did not give correct chips based on 0 cards remaining in deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_and_epitaph__adds_top_six_cards_chips_to_score',
    category = { 'jokers', 'steel_ball_run', 'golden_wind', 'turbo_eyes', 'epitaph' },
    jokers = { 'j_jojoker_turbo_eyes', 'j_jojoker_epitaph' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being dealt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card + 6 4s, *2 because it is triggered for each joker
        Balatest.assert_chips(9 + 4 * 6 * 2, "Turbo Eyes and Epitaph combined did not give correct chips based on top 6 cards of deck")
    end
}
--#endregion
--#region The True Man's World
Balatest.TestPlay {
    name = 'the_true_mans_world_increases_xmult_before_playing_hand',
    category = { 'jokers', 'steel_ball_run', 'the_true_mans_world' },
    jokers = { 'j_jojoker_the_true_mans_world' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local joker_xmult = G.jokers.cards[1].ability.extra.Xmult
        Balatest.assert_eq(1.25, joker_xmult, "The True Man's World did not increase Xmult by 0.25 before playing hand")
    end
}

Balatest.TestPlay {
    name = 'the_true_mans_world_decreases_xmult_when_discarding',
    category = { 'jokers', 'steel_ball_run', 'the_true_mans_world' },
    jokers = { 'j_jojoker_the_true_mans_world' },
    execute = function()
        G.jokers.cards[1].ability.extra.Xmult = 2
        Balatest.discard { '2S' }
    end,
    assert = function()
        local joker_xmult = G.jokers.cards[1].ability.extra.Xmult
        Balatest.assert_eq(1, joker_xmult, "The True Man's World did not reset Xmult to 1 on discard")
    end
}
--#endregion

--#region The First Napkin
Balatest.TestPlay {
    name = 'the_first_napkin_adds_chips_based_on_highest_rank',
    category = { 'jokers', 'steel_ball_run', 'the_first_napkin' },
    jokers = { 'j_jojoker_the_first_napkin' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being dealt
        { r = 'A', s = 'S' },
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = '10', s = 'S' },
        { r = '9', s = 'S' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local ace_extra_chips = G.deck.cards[1].ability.perma_bonus
        local king_extra_chips = G.deck.cards[2].ability.perma_bonus
        local queen_extra_chips = G.deck.cards[3].ability.perma_bonus

        Balatest.assert_eq(ace_extra_chips, 14, "The First Napkin did not give bonus chips to scored Ace")
        Balatest.assert_eq(king_extra_chips, 14, "The First Napkin did not give bonus chips to unscored King")
        Balatest.assert_eq(queen_extra_chips, 14, "The First Napkin did not give bonus chips to unscored Queen")
    end
}

Balatest.TestPlay {
    name = 'the_first_napkin_does_not_add_chips_if_it_has_already_triggered',
    category = { 'jokers', 'steel_ball_run', 'the_first_napkin' },
    jokers = { 'j_jojoker_the_first_napkin' },
    deck = { cards = {
        { r = 'A', s = 'S' },
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = '10', s = 'S' },
        { r = '9', s = 'S' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.has_triggered = true -- Simulate The First Napkin already triggering once
        Balatest.play_hand { 'AS', 'KS', 'QS' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local ace_extra_chips = G.deck.cards[1].ability.perma_bonus
        local king_extra_chips = G.deck.cards[2].ability.perma_bonus
        local queen_extra_chips = G.deck.cards[3].ability.perma_bonus

        Balatest.assert_eq(ace_extra_chips, 0, "The First Napkin gave bonus chips to scored Ace after already triggering")
        Balatest.assert_eq(king_extra_chips, 0, "The First Napkin gave bonus chips to unscored King after already triggering")
        Balatest.assert_eq(queen_extra_chips, 0, "The First Napkin gave bonus chips to unscored Queen after already triggering")
    end
}

Balatest.TestPlay {
    name = 'the_first_napkin_adds_mult_based_on_lowest_rank_when_discarding',
    category = { 'jokers', 'steel_ball_run', 'the_first_napkin' },
    jokers = { 'j_jojoker_the_first_napkin' },
    deck = { cards = {
        { r = 'A', s = 'S' },
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = '10', s = 'S' },
        { r = '9', s = 'S' } } },
    execute = function()
        Balatest.discard { 'AS', 'KS', 'QS' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local ace_extra_mult = G.deck.cards[1].ability.perma_mult
        local king_extra_mult = G.deck.cards[2].ability.perma_mult
        local queen_extra_mult = G.deck.cards[3].ability.perma_mult

        Balatest.assert_eq(ace_extra_mult, 12, "The First Napkin did not give bonus mult to discarded Ace")
        Balatest.assert_eq(king_extra_mult, 12, "The First Napkin did not give bonus mult to discarded King")
        Balatest.assert_eq(queen_extra_mult, 12, "The First Napkin did not give bonus mult to discarded Queen")
    end
}

Balatest.TestPlay {
    name = 'the_first_napkin_does_not_add_mult_if_it_has_already_triggered',
    category = { 'jokers', 'steel_ball_run', 'the_first_napkin' },
    jokers = { 'j_jojoker_the_first_napkin' },
    deck = { cards = {
        { r = 'A', s = 'S' },
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = '10', s = 'S' },
        { r = '9', s = 'S' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.has_triggered = true -- Simulate The First Napkin already triggering once
        Balatest.discard { 'AS', 'KS', 'QS' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local ace_extra_mult = G.deck.cards[1].ability.perma_mult
        local king_extra_mult = G.deck.cards[2].ability.perma_mult
        local queen_extra_mult = G.deck.cards[3].ability.perma_mult

        Balatest.assert_eq(ace_extra_mult, 0, "The First Napkin gave bonus mult to discarded Ace after already triggering")
        Balatest.assert_eq(king_extra_mult, 0, "The First Napkin gave bonus mult to discarded King after already triggering")
        Balatest.assert_eq(queen_extra_mult, 0, "The First Napkin gave bonus mult to discarded Queen after already triggering")
    end
}

Balatest.TestPlay {
    name = 'the_first_napkin_reactivates_after_blind_ends',
    category = { 'jokers', 'steel_ball_run', 'the_first_napkin' },
    jokers = { 'j_jojoker_the_first_napkin' },
    deck = { cards = {
        { r = 'A', s = 'S' },
        { r = 'K', s = 'S' },
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'S' },
        { r = '10', s = 'S' },
        { r = '9', s = 'S' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.has_triggered = true -- Simulate The First Napkin already triggering once
        Balatest.discard { 'AS', 'KS', 'QS' }
        Balatest.next_round()
        G.jokers.cards[1].ability.extra.has_triggered = false -- Simulate The First Napkin reactivating (we cannot make this happen naturally with Balatest)
        Balatest.discard { 'AS', 'KS', 'QS' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local ace_extra_mult = G.deck.cards[1].ability.perma_mult
        local king_extra_mult = G.deck.cards[2].ability.perma_mult
        local queen_extra_mult = G.deck.cards[3].ability.perma_mult

        Balatest.assert_eq(ace_extra_mult, 24, "The First Napkin did not give bonus mult to discarded Ace after reactivating")
        Balatest.assert_eq(king_extra_mult, 24, "The First Napkin did not give bonus mult to discarded King after reactivating")
        Balatest.assert_eq(queen_extra_mult, 24, "The First Napkin did not give bonus mult to discarded Queen after reactivating")
    end
}
--#endregion

--#region Wavering Heart
-- Balatest does not have native support for testing shop rerolls
--#endregion