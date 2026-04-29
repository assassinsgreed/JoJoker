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
        Balatest.assert_eq(1.2, joker_xmult, "The True Man's World did not increase Xmult by 0.2 before playing hand")
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

--#region Dark Determination
Balatest.TestPlay {
    name = 'dark_determination_increases_xmult_when_ending_shop_without_rerolling',
    category = { 'jokers', 'steel_ball_run', 'dark_determination' },
    jokers = { 'j_jojoker_dark_determination' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1.5, "Dark Determination did not increase Xmult correctly after ending shop without rerolling")
    end
}

Balatest.TestPlay {
    name = 'dark_determination_does_notincrease_xmult_when_ending_shop_after_rerolling',
    category = { 'jokers', 'steel_ball_run', 'dark_determination' },
    jokers = { 'j_jojoker_dark_determination' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        G.jokers.cards[1].ability.extra.has_rerolled = true -- Simulate rerolling the shop (we cannot make this happen naturally with Balatest)
        Balatest.exit_shop()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Dark Determination incorrectly increased Xmult after ending shop with rerolling")
    end
}
--#endregion

--#region Left-Side Ataxia
Balatest.TestPlay {
    name = 'left_side_ataxia_gives_no_chips_when_no_jokers_left',
    category = { 'jokers', 'steel_ball_run', 'left_side_ataxia' },
    jokers = { 'j_jojoker_left_side_ataxia', 'j_jojoker_tattoo_you' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local ataxia = G.jokers.cards[1]
        Balatest.assert_eq(0, ataxia.ability.extra.current_chips, "Left Side Ataxia gave chips when no jokers were to its left")
        Balatest.assert_eq(G.jokers.cards[2].debuff, false, "Joker to the right of Left Side Ataxia was disabled")
    end
}

Balatest.TestPlay {
    name = 'left_side_ataxia_gives_correct_chips_and_disables_left_jokers',
    category = { 'jokers', 'steel_ball_run', 'left_side_ataxia' },
    jokers = { 'j_jojoker_oh_lonesome_me', 'j_jojoker_tattoo_you', 'j_jojoker_left_side_ataxia', 'j_jojoker_slow_dancer' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local chips_per_joker = G.jokers.cards[3].ability.extra.chips_per_joker
        Balatest.assert_eq(G.jokers.cards[3].ability.extra.current_chips, 2 * chips_per_joker, "Left Side Ataxia did not give correct chips for two jokers to its left")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.lta_disabled, true, "First joker to the left of Left Side Ataxia was not disabled")
        Balatest.assert_eq(G.jokers.cards[2].ability.extra.lta_disabled, true, "Second joker to the left of Left Side Ataxia was not disabled")
        Balatest.assert_eq(G.jokers.cards[4].debuff, false, "Joker to the right of Left Side Ataxia was disabled")
    end
}

Balatest.TestPlay {
    name = 'left_side_ataxia_updates_disabled_states_when_moved',
    category = { 'jokers', 'steel_ball_run', 'left_side_ataxia' },
    jokers = { 'j_jojoker_left_side_ataxia', 'j_jojoker_oh_lonesome_me', 'j_jojoker_tattoo_you', 'j_jojoker_slow_dancer' },
    execute = function()
        local ataxia = table.remove(G.jokers.cards, 1)
        table.insert(G.jokers.cards, 3, ataxia)
        local disabled = handle_left_side_ataxia_disabling(G.jokers.cards[3])
        G.jokers.cards[3].ability.extra.current_chips = disabled * G.jokers.cards[3].ability.extra.chips_per_joker
    end,
    assert = function()
        local ataxia = G.jokers.cards[3]
        Balatest.assert_eq(ataxia.ability.extra.current_chips, 2 * ataxia.ability.extra.chips_per_joker, "Left Side Ataxia did not update chip total after being moved")
        Balatest.assert(G.jokers.cards[1].ability.extra.lta_disabled, "Joker left of Left Side Ataxia was not disabled after moving")
        Balatest.assert(G.jokers.cards[2].ability.extra.lta_disabled, "Second joker left of Left Side Ataxia was not disabled after moving")
        Balatest.assert_eq(G.jokers.cards[4].debuff, false, "Joker to the right of Left Side Ataxia was disabled after moving")
    end
}

Balatest.TestPlay {
    name = 'left_side_ataxia_added_by_judgment_gives_chips_for_jokers_disabled_by_other_means',
    category = { 'jokers', 'steel_ball_run', 'left_side_ataxia' },
    jokers = { 'j_jojoker_slow_dancer', 'j_jojoker_valkyrie' },
    blind = 'bl_final_heart', -- Crimson Heart, which disables a random joker
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_left_side_ataxia', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.wait()
    end,
    assert = function()
        local ataxia_index = nil
        for i, joker in ipairs(G.jokers.cards) do
            if joker.ability.name == 'left_side_ataxia' then
                ataxia_index = i
                break
            end
        end
        Balatest.assert(ataxia_index, "Left Side Ataxia was not added by Judgment")
        local ataxia = G.jokers.cards[ataxia_index]
        local disabled_count = 0
        local disabled_by_lta = 0
        for _, joker in ipairs(G.jokers.cards) do
            if joker.debuff then
                disabled_count = disabled_count + 1
                if joker.ability.extra.lta_disabled then
                    disabled_by_lta = disabled_by_lta + 1
                end
            end
        end
        Balatest.assert_eq(2 * ataxia.ability.extra.chips_per_joker, ataxia.ability.extra.current_chips, "Left Side Ataxia did not give chips for a joker additionally disabled by Crimson Heart")
        Balatest.assert_eq(disabled_count, 2, "Joker not affected by Crimson Heart was not disabled by Left Side Ataxia")
        Balatest.assert_eq(disabled_by_lta, 2, "Joker affected by Crimson Heart was not additionally disabled by Left Side Ataxia")
    end
}

Balatest.TestPlay {
    name = 'left_side_ataxia_restores_jokers_on_sell',
    category = { 'jokers', 'steel_ball_run', 'left_side_ataxia' },
    jokers = { 'j_jojoker_slow_dancer', 'j_jojoker_valkyrie', 'j_jojoker_left_side_ataxia' },
    execute = function()
        Balatest.sell(function() return G.jokers.cards[3] end)
    end,
    assert = function()
        local disabled_count = 0
        for _, joker in ipairs(G.jokers.cards) do
            if joker.debuff then
                disabled_count = disabled_count + 1
            end
        end
        Balatest.assert_eq(disabled_count, 0, "Jokers were not restored by selling Left Side Ataxia")
    end
}
--#endregion