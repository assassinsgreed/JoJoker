--#region Shizuka

Balatest.TestPlay {
    name = 'shizuka_does_not_level_up_hand_when_wrong_hand_played',
    category = { 'jokers', 'diamond_is_unbreakable', 'shizuka' },
    jokers = { 'j_jojoker_shizuka' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local pair_hand_level = G.GAME.hands["Pair"].level
        Balatest.assert_eq(pair_hand_level, 1, "Pair hand wasn't level 1")
    end
}

Balatest.TestPlay {
    name = 'shizuka_levels_up_hand_3_times_when_correct_hand_played',
    category = { 'jokers', 'diamond_is_unbreakable', 'shizuka' },
    jokers = { 'j_jojoker_shizuka' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 4, "Shizuka didn't level up 2 pair hand after it was played")
    end
}

--#endregion
--#region Yoshikage Kira

Balatest.TestPlay {
    name = 'yoshikage_kira_increases_hands_by_1_when_added',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "Yoshikage Kira didn't increase hands by 1 when added")
    end
}

Balatest.TestPlay {
    name = 'yoshikage_kira_decreases_hands_by_1_when_removed',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 1, "Yoshikage Kira didn't decrease hands by 1 when removed")
    end
}

Balatest.TestPlay {
    name = 'yoshikage_kira_does_not_drain_hands_after_debuff_cycle',
    category = { 'jokers', 'diamond_is_unbreakable', 'yoshikage_kira' },
    jokers = { 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'balatest')
            return true
        end)
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], false, 'balatest')
            return true
        end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 2, "Yoshikage Kira permanently drained a hand after a debuff cycle")
        Balatest.assert_eq(G.GAME.round_resets.hands, 2, "Yoshikage Kira permanently reduced round reset hands after a debuff cycle")
    end
}

--#endregion

--#region Reimi

Balatest.TestPlay {
    name = 'reimi_creates_random_spectral_card_at_end_of_boss_blind',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    blind = 'bl_wheel',
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 1, "Reimi didn't create a spectral card at the end of the boss blind")
        Balatest.assert_eq(spectrals[1].config.center.set, "Spectral", "Reimi's card wasn't spectral rarity")
    end
}

Balatest.TestPlay {
    name = 'reimi_does_not_create_spectral_card_at_end_of_non_boss_blind',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 0, "Reimi created a spectral card at the end of a non-boss blind")
    end
}

Balatest.TestPlay {
    name = 'reimi_does_not_create_spectral_card_when_consumeables_are_full',
    category = { 'jokers', 'diamond_is_unbreakable', 'reimi' },
    jokers = { 'j_jojoker_reimi' },
    blind = 'bl_wheel',
    consumeables = { 'c_mars', 'c_earth' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local spectrals = G.consumeables.cards
        Balatest.assert_eq(#spectrals, 2, "Reimi created a spectral card when consumeables are already full")
        Balatest.assert_eq(spectrals[1].config.center.set, "Planet", "Reimi replaced an existing consumeable")
        Balatest.assert_eq(spectrals[2].config.center.set, "Planet", "Reimi replaced an existing consumeable")
    end
}

--#endregion

--#region Angelo

Balatest.TestPlay {
    name = 'angelo_retriggers_face_and_stone_cards_when_both_score',
    category = { 'jokers', 'diamond_is_unbreakable', 'angelo' },
    jokers = { 'j_jojoker_angelo' },
    deck = { cards = {
        { r = 'K', s = 'S' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '3', s = 'D' } } },
    execute = function()
        Balatest.play_hand { 'KS', '2C' }
    end,
    assert = function()
        local triggers = 1 + G.jokers.cards[1].ability.extra.retriggers
        Balatest.assert_chips(5 + (10 + 50) * triggers, "Angelo did not retrigger the scoring face and Stone cards")
    end
}

Balatest.TestPlay {
    name = 'angelo_retriggers_every_face_and_stone_card_but_not_other_ranks',
    category = { 'jokers', 'diamond_is_unbreakable', 'angelo' },
    jokers = { 'j_jojoker_angelo' },
    deck = { cards = {
        { r = 'K', s = 'S' },
        { r = 'K', s = 'H' },
        { r = '2', s = 'S' },
        { r = '2', s = 'H' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '3', s = 'D' } } },
    execute = function()
        Balatest.play_hand { 'KS', 'KH', '2S', '2H', '2C' }
    end,
    assert = function()
        local triggers = 1 + G.jokers.cards[1].ability.extra.retriggers
        Balatest.assert_chips((20 + (10 + 10 + 50) * triggers + 2 + 2) * 2, "Angelo retriggered the wrong cards in Two Pair")
    end
}

Balatest.TestPlay {
    name = 'angelo_does_not_retrigger_face_card_without_stone_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'angelo' },
    jokers = { 'j_jojoker_angelo' },
    execute = function()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Angelo retriggered a face card with no Stone card scoring")
    end
}

Balatest.TestPlay {
    name = 'angelo_does_not_retrigger_stone_card_without_face_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'angelo' },
    jokers = { 'j_jojoker_angelo' },
    deck = { cards = {
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '3', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(55, "Angelo retriggered a Stone card with no face card scoring")
    end
}

Balatest.TestPlay {
    name = 'angelo_ignores_face_card_that_does_not_score',
    category = { 'jokers', 'diamond_is_unbreakable', 'angelo' },
    jokers = { 'j_jojoker_angelo' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '2', s = 'H' },
        { r = 'K', s = 'S' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '3', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2H', 'KS', '2C' }
    end,
    assert = function()
        Balatest.assert_chips((10 + 2 + 2 + 50) * 2, "Angelo counted a face card that did not score")
    end
}

--#endregion

--#region Hayato

Balatest.TestPlay {
    name = 'hayato_draws_every_second_card_face_down',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' } } },
    hand_size = 4,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(count_face_down_cards(G.hand), 2, "Hayato did not draw every second card face down")
    end
}

Balatest.TestPlay {
    name = 'hayato_keeps_alternating_across_redraws',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' } } },
    hand_size = 3,
    execute = function()
        Balatest.discard { '2S', '2S', '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.draws, 6, "Hayato did not count every card drawn")
        Balatest.assert_eq(count_face_down_cards(G.hand), 2, "Hayato restarted the alternation after the redraw")
    end
}

Balatest.TestPlay {
    name = 'hayato_gives_xmult_per_face_down_card_in_the_poker_hand',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '3', s = 'D' } } },
    hand_size = 3,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', 'KH' }
    end,
    assert = function()
        local xmult = 1 + G.jokers.cards[1].ability.extra.xmult_mod * 2
        Balatest.assert_chips((10 + 10 + 10) * 2 * xmult, "Hayato did not give X1 plus X1 per face down card for a face down Pair")
    end
}

Balatest.TestPlay {
    name = 'hayato_gives_xmult_for_every_card_of_a_face_down_full_house',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = 'K', s = 'D' }, { r = '3', s = 'D' }, { r = '3', s = 'C' }, { r = '4', s = 'C' } } },
    hand_size = 6,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', 'KH', 'KD', '3D', '3C' }
    end,
    assert = function()
        local xmult = 1 + G.jokers.cards[1].ability.extra.xmult_mod * 5
        Balatest.assert_chips((40 + 10 + 10 + 10 + 3 + 3) * 4 * xmult, "Hayato did not give X1 plus X1 per face down card for a face down Full House")
    end
}

Balatest.TestPlay {
    name = 'hayato_only_counts_face_down_cards_when_mixed_with_face_up_ones',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '3', s = 'D' } } },
    hand_size = 3,
    execute = function()
        set_hand_facing('back')
        Balatest.q(function() find_playing_card('King', 'Spades'):flip() end)
        Balatest.play_hand { 'KS', 'KH' }
    end,
    assert = function()
        local xmult = 1 + G.jokers.cards[1].ability.extra.xmult_mod
        Balatest.assert_chips((10 + 10 + 10) * 2 * xmult, "Hayato did not give X1 for the one face down card in a mixed Pair")
    end
}

Balatest.TestPlay {
    name = 'hayato_ignores_face_up_cards_outside_the_poker_hand',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '3', s = 'D' }, { r = '4', s = 'C' } } },
    hand_size = 4,
    execute = function()
        set_hand_facing('back')
        Balatest.q(function() find_playing_card('3', 'Diamonds'):flip() end)
        Balatest.play_hand { 'KS', 'KH', '3D' }
    end,
    assert = function()
        local xmult = 1 + G.jokers.cards[1].ability.extra.xmult_mod * 2
        Balatest.assert_chips((10 + 10 + 10) * 2 * xmult, "Hayato lost its xmult because of a face up card outside the poker hand")
    end
}

Balatest.TestPlay {
    name = 'hayato_loses_all_xmult_when_a_face_down_card_is_outside_the_poker_hand',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = 'K', s = 'D' }, { r = '3', s = 'D' }, { r = '4', s = 'C' } } },
    hand_size = 5,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', 'KH', 'KD', '3D' }
    end,
    assert = function()
        Balatest.assert_chips((30 + 10 + 10 + 10) * 3, "Hayato gave xmult even though a face down card was outside the poker hand")
    end
}

Balatest.TestPlay {
    name = 'hayato_does_not_give_xmult_without_face_down_cards',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '3', s = 'D' } } },
    hand_size = 3,
    execute = function()
        set_hand_facing('front')
        Balatest.play_hand { 'KS', 'KH' }
    end,
    assert = function()
        Balatest.assert_chips((10 + 10 + 10) * 2, "Hayato gave xmult with no face down cards played")
    end
}

Balatest.TestPlay {
    name = 'hayato_does_not_give_xmult_for_a_single_face_down_high_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = '3', s = 'D' } } },
    hand_size = 2,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 10, "Hayato gave xmult for a lone face down High Card")
    end
}

Balatest.TestPlay {
    name = 'hayato_does_not_give_xmult_for_a_face_down_high_card_scored_by_survivor',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato', 'j_jojoker_survivor' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = '9', s = 'D' }, { r = '7', s = 'C' }, { r = '5', s = 'H' }, { r = '3', s = 'S' }, { r = '2', s = 'D' } } },
    hand_size = 6,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', '9D', '7C', '5H', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 10 + 9 + 7 + 5 + 3, "Hayato counted Survivor's extra scored cards as part of a High Card")
    end
}

Balatest.TestPlay {
    name = 'hayato_loses_all_xmult_when_survivor_scores_a_face_down_card_outside_the_poker_hand',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato', 'j_jojoker_survivor' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '9', s = 'D' }, { r = '7', s = 'C' }, { r = '3', s = 'S' }, { r = '2', s = 'D' } } },
    hand_size = 6,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', 'KH', '9D', '7C', '3S' }
    end,
    assert = function()
        Balatest.assert_chips((10 + 10 + 10 + 9 + 7 + 3) * 2, "Hayato counted Survivor's extra scored cards as part of the Pair")
    end
}

Balatest.TestPlay {
    name = 'hayato_clears_face_down_marks_after_the_hand',
    category = { 'jokers', 'diamond_is_unbreakable', 'hayato' },
    jokers = { 'j_jojoker_hayato' },
    deck = { cards = { { r = 'K', s = 'S' }, { r = 'K', s = 'H' }, { r = '3', s = 'D' } } },
    hand_size = 3,
    execute = function()
        set_hand_facing('back')
        Balatest.play_hand { 'KS', 'KH' }
    end,
    assert = function()
        Balatest.assert_eq(find_playing_card('King', 'Spades').ability.jojoker_played_face_down, nil, "Hayato left a face down mark on a played card")
    end
}

--#endregion
