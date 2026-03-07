--#region Joseph Joestar
Balatest.TestPlay {
    name = 'joseph_does_not_level_up_hand_when_wrong_hand_played',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 1, "Two Pair hand wasn't level 1")
    end
}
Balatest.TestPlay {
    name = 'joseph_levels_up_hand_when_correct_hand_played',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 2, "Joseph didn't level up 2 pair hand after it was played")
    end
}
Balatest.TestPlay {
    name = 'joseph_levels_up_hand_multiple_times_per_blind',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
        Balatest.play_hand { '3S', '3C', '8H', '8D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 3, "Joseph didn't level up two pair hand to level 3, after it was played twice")
    end
}
Balatest.TestPlay {
    name = 'joseph_does_not_level_up_two_pair_contained_in_full_house',
    category = { 'jokers', 'battle_tendency', 'joseph_joestar' },
    jokers = { 'j_jojoker_joseph_joestar' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type_name = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_name = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D', '7S' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 1, "Joseph levelled up Two Pair hand when Full House was played, but should not have")
    end
}
--#endregion
--#region Esidisi
Balatest.TestPlay {
    name = 'esidisi_xmult_does_not_increase_when_score_on_fire',
    category = { 'jokers', 'battle_tendency', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Esidisi Xmult was changed when score did not catch fire")
    end
}
Balatest.TestPlay {
    name = 'esidisi_xmult_increases_when_score_on_fire',
    category = { 'jokers', 'battle_tendency', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 2, "Esidisi didn't increase Xmult when score caught fire")
    end
}
Balatest.TestPlay {
    name = 'esidisi_xmult_increases_when_score_on_fire_in_subsequent_rounds',
    category = { 'jokers', 'battle_tendency', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
        Balatest.next_round()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 3, "Esidisi didn't increase Xmult when score caught fire")
    end
}
Balatest.TestPlay {
    name = 'esidisi_gives_enhanced_xmult_when_score_does_not_catch_fire',
    category = { 'jokers', 'battle_tendency', 'esidisi' },
    jokers = { 'j_jojoker_esidisi' },
    execute = function()
        G.jokers.cards[1].ability.extra.Xmult = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14, "Esidisi didn't apply increased Xmult when score was not on fire")
    end
}
--#endregion
--#region Speedwagon
Balatest.TestPlay {
    name = 'speedwagon_gives_no_money_when_discarding',
    category = { 'jokers', 'battle_tendency', 'speedwagon_bt' },
    jokers = { 'j_jojoker_speedwagon_bt' },
    execute = function()
        Balatest.discard { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Speedwagon gave money when not playing a hand")
    end
}
Balatest.TestPlay {
    name = 'speedwagon_gives_money_when_hand_played',
    category = { 'jokers', 'battle_tendency', 'speedwagon_bt' },
    jokers = { 'j_jojoker_speedwagon_bt' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_mod, "Speedwagon did not give money when playing a hand")
    end
}
Balatest.TestPlay {
    name = 'speedwagon_gives_money_regardless_of_number_of_scored_cards',
    category = { 'jokers', 'battle_tendency', 'speedwagon_bt' },
    jokers = { 'j_jojoker_speedwagon_bt' },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_mod, "Speedwagon gave too much money when playing a hand")
    end
}
--#endregion
--#region Caesar
Balatest.TestPlay {
    name = 'caesar_gives_stone_cards_xmult_and_destroys_them',
    category = { 'jokers', 'battle_tendency', 'caesar' },
    jokers = { 'j_jojoker_caesar' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        local expectdMult = G.jokers.cards[1].ability.extra.Xmult_mod ^ 2
        Balatest.assert_chips(expectdMult * 107, "Caesar didn't give xmult for each stone card") -- (7 from hand + 50 per stone card) * xmult from 2 stone cards
        Balatest.assert_eq(#G.deck.cards, 1, "Caesar didn't destroy stone cards after scoring")
    end
}
--#endregion
--#region Kars (Ultimate Lifeform)
Balatest.TestPlay {
    name = 'kars_gives_1x_mult_by_default',
    category = { 'jokers', 'battle_tendency', 'kars_ultimate_lifeform' },
    jokers = { 'j_jojoker_kars_ultimate_lifeform' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Kars (Ultimate Lifeform) does not start with 1x mult")
    end
}
Balatest.TestPlay {
    name = 'kars_gives_xmult_boost_once_with_duplicate_planets_played',
    category = { 'jokers', 'battle_tendency', 'kars_ultimate_lifeform' },
    jokers = { 'j_jojoker_kars_ultimate_lifeform' },
    consumeables = { 'c_mars', 'c_mars' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[2])
    end,
    assert = function()
        local expectedXmult = G.jokers.cards[1].ability.extra.Xmult_mod * 1 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expectedXmult, "Kars (Ultimate Lifeform) did not give expected xmult for duplicate planet cards")
    end
}
Balatest.TestPlay {
    name = 'kars_gives_xmult_boost_for_each_unique_played_planet',
    category = { 'jokers', 'battle_tendency', 'kars_ultimate_lifeform' },
    jokers = { 'j_jojoker_kars_ultimate_lifeform' },
    consumeables = { 'c_mars', 'c_earth' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[2])
    end,
    assert = function()
        local expectedXmult = G.jokers.cards[1].ability.extra.Xmult_mod * 2 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expectedXmult, "Kars (Ultimate Lifeform) did not give expected xmult for unique planet cards")
    end
}
Balatest.TestPlay {
    name = 'kars_transforms_to_stop_thinking_when_expired',
    category = { 'jokers', 'battle_tendency', 'kars_ultimate_lifeform' },
    jokers = { 'j_jojoker_kars_ultimate_lifeform' },
    execute = function()
        G.jokers.cards[1].ability.extra.current_rounds_left = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].config.center, G.P_CENTERS['j_jojoker_kars_stopped_thinking'], "Kars (Ultimate Lifeform) did not transform to Kars (Stopped Thinking) once expired")
    end
}
--#endregion
--#region Suzie Q
Balatest.TestPlay {
    name = 'suzi_q_gives_gold_seal_to_scored_queen_with_no_other_seals',
    category = { 'jokers', 'battle_tendency', 'suzi_q' },
    jokers = { 'j_jojoker_suzi_q' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queenSeal = G.deck.cards[1].seal
        Balatest.assert_eq(queenSeal, 'Gold', "Suzie Q didn't give gold seal to scored queen with no other seals")
    end
}

Balatest.TestPlay {
    name = 'suzi_q_gives_gold_seal_to_every_scored_queen_with_no_other_seals',
    category = { 'jokers', 'battle_tendency', 'suzi_q' },
    jokers = { 'j_jojoker_suzi_q' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'QS', 'QC' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queenSeal1 = G.deck.cards[1].seal
        local queenSeal2 = G.deck.cards[2].seal
        Balatest.assert_eq(queenSeal1, 'Gold', "Suzie Q didn't give gold seal to scored queen with no other seals")
        Balatest.assert_eq(queenSeal2, 'Gold', "Suzie Q didn't give gold seal to scored queen with no other seals")
    end
}

Balatest.TestPlay {
    name = 'suzi_q_does_not_give_gold_seal_to_scored_queen_with_other_seals',
    category = { 'jokers', 'battle_tendency', 'suzi_q' },
    jokers = { 'j_jojoker_suzi_q' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.hand.cards[1].seal = 'Red' -- Manually give non-gold seal to queen to test that gold seal is not given
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queenSeal = G.deck.cards[1].seal
        Balatest.assert_eq(queenSeal, 'Red', "Suzie Q incorrectly gave gold seal to scored queen with other seals")
    end
}

Balatest.TestPlay {
    name = 'suzi_q_does_not_give_gold_seal_to_scored_non_queen',
    category = { 'jokers', 'battle_tendency', 'suzi_q' },
    jokers = { 'j_jojoker_suzi_q' },
    deck = { cards = {
        { r = 'Q', s = 'S', seal = 'Red' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '5H' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local fiveSeal = G.deck.cards[3].seal
        Balatest.assert_eq(fiveSeal, nil, "Suzie Q incorrectly gave gold seal to scored non-queen")
    end
}
--#endregion

--#region NYPD
Balatest.TestPlay {
    name = 'nypd_gives_no_mult_for_non_clubs_cards',
    category = { 'jokers', 'battle_tendency', 'nypd' },
    jokers = { 'j_jojoker_nypd' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "NYPD incorrectly gave mult for non-clubs card")
    end
}
Balatest.TestPlay {
    name = 'nypd_gives_mult_for_single_clubs_card',
    category = { 'jokers', 'battle_tendency', 'nypd' },
    jokers = { 'j_jojoker_nypd' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "NYPD incorrectly gave mult for single clubs card")
    end
}
Balatest.TestPlay {
    name = 'nypd_gives_mult_for_each_scored_clubs_card',
    category = { 'jokers', 'battle_tendency', 'nypd' },
    jokers = { 'j_jojoker_nypd' },
    execute = function()
        Balatest.play_hand { '2C', '3C', '5C', '7C', '8C' }
    end,
    assert = function()
        Balatest.assert_chips(60 * (G.jokers.cards[1].ability.extra.mult * 5 + 4), "NYPD incorrectly gave mult for multiple scored clubs cards")
    end
}
--#endregion

--#region Santana
Balatest.TestPlay {
    name = 'santana_increases_chips_of_scored_face_cards',
    category = { 'jokers', 'battle_tendency', 'santana' },
    jokers = { 'j_jojoker_santana' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'H' },
        { r = '5', s = 'H' },
        { r = '5', s = 'C' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH', 'QH' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstFacePermaChips = G.deck.cards[1].ability.perma_bonus
        local secondFacePermaChips = G.deck.cards[2].ability.perma_bonus
        Balatest.assert_eq(firstFacePermaChips, G.jokers.cards[1].ability.extra.chips_mod, "Santana did not permanently increase chips of first scored face card.")
        Balatest.assert_eq(secondFacePermaChips, G.jokers.cards[1].ability.extra.chips_mod, "Santana did not permanently increase chips of second scored face card.")
    end
}

Balatest.TestPlay {
    name = 'santana_further_increases_chips_bonus_of_already_increased_face_cards',
    category = { 'jokers', 'battle_tendency', 'santana' },
    jokers = { 'j_jojoker_santana' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH' } -- Play all and check the deck afterward
        Balatest.next_round()
        Balatest.play_hand { 'QH' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstFaceCardPermaChips = G.deck.cards[1].ability.perma_bonus
        Balatest.assert_eq(firstFaceCardPermaChips, G.jokers.cards[1].ability.extra.chips_mod * 2, "Santana did not permanently increase chips of first scored face card.")
    end
}

Balatest.TestPlay {
    name = 'santana_does_not_increase_bonus_chips_of_non_face_cards',
    category = { 'jokers', 'battle_tendency', 'santana' },
    jokers = { 'j_jojoker_santana' },
    deck = { cards = {
        { r = 'Q', s = 'C' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'C' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '5C' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local fivePermaChips = G.deck.cards[3].ability.perma_bonus
        Balatest.assert_eq(fivePermaChips, 0, "Santana incorrectly increased chips of non-face card.")
    end
}
--#endregion

--#region Stroheim
Balatest.TestPlay {
    name = 'stroheim_gives_chips_on_played_hand',
    category = { 'jokers', 'battle_tendency', 'stroheim' },
    jokers = { 'j_jojoker_stroheim' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.starting_chips, "Stroheim did not give chips on played hand.")
    end
}

Balatest.TestPlay {
    name = 'stroheim_chips_given_decreases_on_played_hand',
    category = { 'jokers', 'battle_tendency', 'stroheim' },
    jokers = { 'j_jojoker_stroheim' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        local stroheimChips = G.jokers.cards[1].ability.extra.chips_remaining
        Balatest.assert_eq(stroheimChips, G.jokers.cards[1].ability.extra.starting_chips - G.jokers.cards[1].ability.extra.chips_loss, "Stroheim did not reduce chip reward on played hand.")
    end
}

Balatest.TestPlay {
    name = 'stroheim_evolves_when_chips_hit_zero',
    category = { 'jokers', 'battle_tendency', 'stroheim' },
    jokers = { 'j_jojoker_stroheim' },
    execute = function()
        G.jokers.cards[1].ability.extra.chips_remaining = 0 -- Ensure next hand played causes evolution
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].config.center, G.P_CENTERS['j_jojoker_stroheim_german_engineering'], "Stroheim did not evolve when chips hit zero.")
    end
}
--#endregion

--#region Stroheim (German Engineering)
Balatest.TestPlay {
    name = 'stroheim_german_engineering_gives_mult_on_played_hand',
    category = { 'jokers', 'battle_tendency', 'stroheim_german_engineering' },
    jokers = { 'j_jojoker_stroheim_german_engineering' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.starting_mult + 1), "Stroheim did not give mult on played hand.")
    end
}

Balatest.TestPlay {
    name = 'stroheim_german_engineering_does_not_gain_mult_on_played_hand',
    category = { 'jokers', 'battle_tendency', 'stroheim_german_engineering' },
    jokers = { 'j_jojoker_stroheim_german_engineering' },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        local stroheimMult = G.jokers.cards[1].ability.extra.current_mult
        Balatest.assert_eq(stroheimMult, G.jokers.cards[1].ability.extra.starting_mult, "Stroheim gained mult on played hand.")
    end
}

Balatest.TestPlay {
    name = 'stroheim_german_engineering_gains_mult_on_blind_end',
    category = { 'jokers', 'battle_tendency', 'stroheim_german_engineering' },
    jokers = { 'j_jojoker_stroheim_german_engineering' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local stroheimMult = G.jokers.cards[1].ability.extra.current_mult
        Balatest.assert_eq(stroheimMult, G.jokers.cards[1].ability.extra.starting_mult + G.jokers.cards[1].ability.extra.mult_gain, "Stroheim did not gain mult on blind end.")
    end
}
--#endregion