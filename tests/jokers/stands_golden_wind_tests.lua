--#region Sex Pistols

Balatest.TestPlay {
    name = 'sex_pistols_no_mult_when_invalid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Sex Pistols mult wasn't 0 when no valid rank present")
    end
}

Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_correctly_based_on_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7")
    end
}

Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7 and a 2")
    end
}

Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_instance_of_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '7C' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing two 7s")
    end
}

Balatest.TestPlay {
    name = 'sex_pistols_does_not_gain_mult_from_debuffed_matching_ace',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "Ace"
        Balatest.q(function()
            for _, v in ipairs(G.hand.cards) do
                if v:get_id() == 14 and v.base.suit == 'Spades' then
                    SMODS.debuff_card(v, true, 'balatest')
                    break
                end
            end
            return true
        end)
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Sex Pistols gained mult from a debuffed Ace")
    end
}

--#endregion

--#region Grateful Dead

Balatest.TestPlay {
    name = 'grateful_dead_starts_with_correct_mult',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.starting_mult + 1), "Grateful Dead mult started decayed.")
    end
}

Balatest.TestPlay {
    name = 'grateful_dead_mult_decays_on_round_end',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        local new_mult = G.jokers.cards[1].ability.extra.mult
        Balatest.assert_eq(new_mult, G.jokers.cards[1].ability.extra.starting_mult - G.jokers.cards[1].ability.extra.mult_decay, "Grateful Dead mult didn't decay at the end of the round.")
    end
}

Balatest.TestPlay {
    name = 'grateful_dead_mult_cannot_decay_below_zero',
    category = { 'jokers', 'golden_wind', 'grateful_dead' },
    jokers = { 'j_jojoker_grateful_dead' },
    execute = function()
        G.jokers.cards[1].ability.extra.mult = 0
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(0, G.jokers.cards[1].ability.extra.mult, "Grateful Dead mult decayed below zero.")
    end
}

--#endregion

--#region Spice Girl

Balatest.TestPlay {
    name = 'spice_girl_increases_chips_for_each_scored_stone_cards',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_chips = G.jokers.cards[1].ability.extra.chips_mod * 2
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, expected_chips, "Spice Girl chips wasn't "..expected_chips.." after playing two stone cards")
    end
}

Balatest.TestPlay {
    name = 'spice_girl_increases_xmult_for_single_scored_steel_card',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '3', s = 'C', e = 'm_steel' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        local expected_xmult = G.jokers.cards[1].ability.extra.Xmult_mod + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Spice Girl xmult wasn't "..expected_xmult.." after scoring one steel card")
    end
}

Balatest.TestPlay {
    name = 'spice_girl_increases_xmult_for_each_scored_steel_cards',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '2', s = 'C', e = 'm_steel' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_xmult = G.jokers.cards[1].ability.extra.Xmult_mod * 2 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Spice Girl xmult wasn't "..expected_xmult.." after scoring one steel card")
    end
}

Balatest.TestPlay {
    name = 'spice_girl_applies_xmult_when_scoring',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '2', s = 'C' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        -- Pair of 2s: (10 + 2 + 2) chips * 2 mult * X1.25 from the removed steel enhancement
        Balatest.assert_chips(35, "Spice Girl did not apply its Xmult during scoring")
    end
}

--#endregion
--#region Sticky Fingers

Balatest.TestPlay {
    name = 'sticky_fingers_applies_four_fingers',
    category = { 'jokers', 'golden_wind', 'sticky_fingers' },
    jokers = { 'j_jojoker_sticky_fingers' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4H', '5D' }
    end,
    assert = function()
        local straights_played = G.GAME.hands["Straight"].played_this_round
        Balatest.assert_eq(straights_played, 1, "Sticky Fingers did not apply four fingers and score a straight")
    end
}

--#endregion
--#region Gold Experience

Balatest.TestPlay {
    name = 'gold_experience_gives_polychrome_edition_to_scored_card_without_edition',
    category = { 'jokers', 'golden_wind', 'gold_experience' },
    jokers = { 'j_jojoker_gold_experience' },
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
        local queenEdition = G.deck.cards[1].edition.key
        Balatest.assert_eq(queenEdition, 'e_polychrome', "Gold Experience didn't give polychrome edition to scored card with no other editions")
    end
}

Balatest.TestPlay {
    name = 'gold_experience_gives_polychrome_edition_to_multiple_scored_cards_without_edition',
    category = { 'jokers', 'golden_wind', 'gold_experience' },
    jokers = { 'j_jojoker_gold_experience' },
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
        local queenEdition1 = G.deck.cards[1].edition.key
        local queenEdition2 = G.deck.cards[2].edition.key
        Balatest.assert_eq(queenEdition1, 'e_polychrome', "Gold Experience didn't give polychrome edition to scored card with no other editions")
        Balatest.assert_eq(queenEdition2, 'e_polychrome', "Gold Experience didn't give polychrome edition to scored card with no other editions")
    end
}

Balatest.TestPlay {
    name = 'gold_experience_does_not_give_polychrome_to_card_with_an_existing_edition',
    category = { 'jokers', 'golden_wind', 'gold_experience' },
    jokers = { 'j_jojoker_gold_experience' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        G.hand.cards[1]:set_edition("e_foil")
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queenEdition1 = G.deck.cards[1].edition.key
        Balatest.assert_eq(queenEdition1, 'e_foil', "Gold Experience incorrectly gave polychrome edition to card with existing edition")
    end
}

--#endregion
--#region Gold Experience Requiem

Balatest.TestPlay {
    name = 'gold_experience_requiem_disables_boss_blinds',
    category = { 'jokers', 'golden_wind', 'gold_experience_requiem' },
    jokers = { 'j_jojoker_gold_experience_requiem' },
    dollars = 10,
    blind = 'bl_wheel',
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.blind.disabled, true, "Gold Experience Requiem didn't disable boss blind automatically")
    end
}

--#endregion
--#region King Crimson

Balatest.TestPlay {
    name = 'king_crimson_gives_xmult_for_each_skipped_blind',
    category = { 'jokers', 'golden_wind', 'king_crimson' },
    jokers = { 'j_jojoker_king_crimson' },
    execute = function()
        G.GAME.skips = 2
        Balatest.wait()
    end,
    assert = function()
        local king_crimson_xmult = G.jokers.cards[1].ability.extra.Xmult
        Balatest.assert_eq(king_crimson_xmult, 1 + G.jokers.cards[1].ability.extra.Xmult_mod * 2, "King Crimson doesn't have expected xmult for 2 skipped blinds")
    end
}

--#endregion
--#region Moody Blues

Balatest.TestPlay {
    name = 'moody_blues_retriggers_scored_cards',
    category = { 'jokers', 'golden_wind', 'moody_blues' },
    jokers = { 'j_jojoker_moody_blues' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 2 * 2, "Moody Blues did not retrigger scored cards correctly")
    end
}

--#endregion
--#region Baby Face

Balatest.TestPlay {
    name = 'baby_face_creates_negative_common_joker',
    category = { 'jokers', 'golden_wind', 'baby_face' },
    jokers = { 'j_jojoker_baby_face' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Baby Face did not create negative common joker correctly")
        Balatest.assert_eq(G.jokers.cards[2].edition.key, "e_negative", "Baby Face did not create negative joker")
        Balatest.assert_eq(G.jokers.cards[2].config.center.rarity, 1, "Baby Face did not create common joker")
    end
}

--#endregion
--#region Little Feet

Balatest.TestPlay {
    name = 'little_feet_debuffs_face_cards_in_deck',
    category = { 'jokers', 'golden_wind', 'little_feet' },
    jokers = { 'j_jojoker_little_feet' },
    hands = 3,
    execute = function()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(5, "Little Feet did not debuff face cards in deck correctly")
    end
}

Balatest.TestPlay {
    name = 'little_feet_restores_face_cards_when_sold',
    category = { 'jokers', 'golden_wind', 'little_feet' },
    jokers = { 'j_jojoker_little_feet' },
    hands = 3,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Little Feet did not restore face cards correctly when sold")
    end
}

Balatest.TestPlay {
    name = 'little_feet_gives_xmult_for_each_low_card',
    category = { 'jokers', 'golden_wind', 'little_feet' },
    jokers = { 'j_jojoker_little_feet' },
    hands = 3,
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(14 * (2 * (G.jokers.cards[1].ability.extra.Xmult ^ 2)), "Little Feet did not give xmult for each low card correctly")
    end
}

--#endregion
--#region Black Sabbath

Balatest.TestPlay {
    name = 'black_sabbath_gives_chips_and_mult_when_hand_scores',
    category = { 'jokers', 'golden_wind', 'black_sabbath' },
    jokers = { 'j_jojoker_black_sabbath' },
    hands = 3,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(517, "Black Sabbath did not give chips and mult correctly when hand scores")
    end
}

Balatest.TestPlay {
    name = 'black_sabbath_becomes_perishable_with_enhanced_chips_and_mult_when_hand_scores_above_blind_threshold',
    category = { 'jokers', 'golden_wind', 'black_sabbath' },
    jokers = { 'j_jojoker_black_sabbath' },
    hands = 3,
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        local isPerishable = G.jokers.cards[1].ability.perishable
        local newChips = G.jokers.cards[1].ability.extra.curr_chips
        local newMult = G.jokers.cards[1].ability.extra.curr_mult

        Balatest.assert(isPerishable, "Black Sabbath did not become perishable with enhanced chips and mult when hand scores above blind threshold")
        Balatest.assert_eq(newChips, G.jokers.cards[1].ability.extra.enhanced_chips, "Black Sabbath did not set enhanced chips correctly when hand scores above blind threshold")
        Balatest.assert_eq(newMult, G.jokers.cards[1].ability.extra.enhanced_mult, "Black Sabbath did not set enhanced mult correctly when hand scores above blind threshold")
    end
}

Balatest.TestPlay {
    name = 'black_sabbath_does_not_reset_perishable_tally_when_hand_scores_above_blind_threshold',
    category = { 'jokers', 'golden_wind', 'black_sabbath' },
    jokers = { 'j_jojoker_black_sabbath' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.perishable = true
        G.jokers.cards[1].ability.perish_tally = 3
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        local isPerishable = G.jokers.cards[1].ability.perishable
        local perishTally = G.jokers.cards[1].ability.perish_tally -- Should be 1 less than original, since this hand will clear blind

        Balatest.assert(isPerishable, "Black Sabbath did not become perishable with enhanced chips and mult when hand scores above blind threshold")
        Balatest.assert_eq(perishTally, 2, "Black Sabbath did not preserve perish tally when hand scores above blind threshold")
    end
}

--#endregion
--#region Rolling Stones

Balatest.TestPlay {
    name = 'rolling_stones_gives_xmult',
    category = { 'jokers', 'golden_wind', 'rolling_stones' },
    jokers = { 'j_jojoker_rolling_stones' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * G.jokers.cards[1].ability.extra.XMult, "Rolling Stones did not give Xmult correctly")
    end
}

Balatest.TestPlay {
    name = 'rolling_stones_zeroes_out_probabilities',
    category = { 'jokers', 'golden_wind', 'rolling_stones' },
    jokers = { 'j_jojoker_rolling_stones' },
    deck = { cards = {
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = 'A', s = 'S', e = 'm_glass' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', 'AS', 'AS', 'AS' } -- We use unshatterable glass cards to test that probabilities are zeroed out, since they would normally shatter and be removed from the deck
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 5, "Love Train did not prevent glass card from shattering")
    end
}

--#endregion
--#region Notorious B.I.G.

Balatest.TestPlay {
    name = 'notorious_big_gives_xmult_to_death_thirteen_when_destroyed_by_it',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_notorious_big', 'j_jojoker_death_thirteen' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Death Thirteen did not destroy Notorious B.I.G.")
        Balatest.assert_eq(G.jokers.cards[1].ability.jojoker_notorious_xmult, notorious_big_xmult(), "Death Thirteen did not gain Notorious Xmult when it destroyed Notorious B.I.G.")
    end
}

Balatest.TestPlay {
    name = 'notorious_big_gives_xmult_to_danny_sbr_when_destroyed_by_it',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_notorious_big' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Danny SBR did not destroy Notorious B.I.G.")
        Balatest.assert_eq(G.jokers.cards[1].ability.jojoker_notorious_xmult, notorious_big_xmult(), "Danny SBR did not gain Notorious Xmult when it destroyed Notorious B.I.G.")
    end
}

Balatest.TestPlay {
    name = 'notorious_big_xmult_stacks_when_wonder_of_u_destroys_two',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_wonder_of_u', 'j_jojoker_notorious_big', 'j_jojoker_notorious_big' },
    execute = function()
        G.jokers.cards[1].ability.extra.rounds_left = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Wonder of U did not destroy both Notorious B.I.G.s")
        Balatest.assert_eq(G.jokers.cards[1].ability.jojoker_notorious_xmult, 2 * notorious_big_xmult(), "Wonder of U did not gain Notorious Xmult for each Notorious B.I.G. it destroyed")
    end
}

Balatest.TestPlay {
    name = 'notorious_big_gives_no_xmult_when_another_joker_is_destroyed',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_sex_pistols', 'j_jojoker_death_thirteen', 'j_jojoker_notorious_big' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Death Thirteen did not destroy only the joker to its left")
        Balatest.assert_eq(G.jokers.cards[2].ability.name, "notorious_big", "Notorious B.I.G. was destroyed instead of the joker to Death Thirteen's left")
        Balatest.assert(not G.jokers.cards[1].ability.jojoker_notorious_xmult, "Death Thirteen gained Notorious Xmult without destroying Notorious B.I.G.")
    end
}

Balatest.TestPlay {
    name = 'notorious_big_xmult_is_applied_when_destroyer_scores',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_notorious_big' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_jojoker_danny_sbr', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        -- Pair: (10 + 2 + 2) chips x 2 mult, then Danny SBR's X2 and Notorious X2.5
        Balatest.assert_chips(140, "Notorious Xmult was not applied when Danny SBR scored")
    end
}

Balatest.TestPlay {
    name = 'notorious_big_xmult_is_applied_after_the_destroyers_own_effect',
    category = { 'jokers', 'golden_wind', 'notorious_big' },
    jokers = { 'j_jojoker_notorious_big', 'j_jojoker_death_thirteen' },
    execute = function()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        -- Pair: (10 + 2 + 2) chips x (2 + Death Thirteen's 1 + 2 * 3 sell value) mult, then Notorious X2.5
        Balatest.assert_chips(315, "Notorious Xmult was not applied after Death Thirteen's +Mult")
    end
}

--#endregion
--#region White Album

Balatest.TestPlay {
    name = 'white_album_freezes_perishable_countdown',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[2].ability.perishable = true
        G.jokers.cards[2].ability.perish_tally = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.perish_tally, 1, "White Album did not freeze the perishable countdown")
        Balatest.assert(not G.jokers.cards[2].debuff, "White Album let a perishable joker perish")
    end
}

Balatest.TestPlay {
    name = 'white_album_freezes_perishable_countdown_across_rounds',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[2].ability.perishable = true
        G.jokers.cards[2].ability.perish_tally = 2
        Balatest.next_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.perish_tally, 2, "White Album did not keep the perishable countdown frozen across rounds")
    end
}

Balatest.TestPlay {
    name = 'perishable_countdown_resumes_after_white_album_is_sold',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[2].ability.perishable = true
        G.jokers.cards[2].ability.perish_tally = 1
        Balatest.sell(function() return G.jokers.cards[1] end)
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.perish_tally, 0, "Perishable countdown did not resume after White Album was sold")
        Balatest.assert(G.jokers.cards[1].debuff, "Perishable joker did not perish after White Album was sold")
    end
}

Balatest.TestPlay {
    name = 'white_album_does_not_revive_perished_joker',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[2].ability.perishable = true
        G.jokers.cards[2].ability.perish_tally = 0
        G.jokers.cards[2]:set_debuff()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[2].debuff, "White Album revived a perished joker")
    end
}

Balatest.TestPlay {
    name = 'white_album_freezes_black_sabbath_after_it_becomes_perishable',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_black_sabbath' },
    hands = 3,
    execute = function()
        Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', '10S' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[2].ability.perishable, "Black Sabbath did not become perishable while White Album was held")
        Balatest.assert_eq(G.jokers.cards[2].ability.perish_tally, G.GAME.perishable_rounds, "White Album did not freeze Black Sabbath's new perishable countdown")
    end
}

local white_album_perishable_rolls

Balatest.TestPlay {
    name = 'white_album_prevents_shop_jokers_from_rolling_perishable',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_white_album' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() white_album_perishable_rolls = count_perishable_shop_rolls(30) end)
    end,
    assert = function()
        Balatest.assert_eq(white_album_perishable_rolls, 0, "A shop joker rolled perishable while White Album was held")
    end
}

local unprotected_perishable_rolls

Balatest.TestPlay {
    name = 'shop_jokers_roll_perishable_without_white_album',
    category = { 'jokers', 'golden_wind', 'white_album' },
    jokers = { 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() unprotected_perishable_rolls = count_perishable_shop_rolls(30) end)
    end,
    assert = function()
        Balatest.assert(unprotected_perishable_rolls > 0, "No shop joker rolled perishable without White Album, so the White Album shop test proves nothing")
    end
}

--#endregion
--#region Aerosmith

Balatest.TestPlay {
    name = 'aerosmith_gives_xmult_per_unscored_card_in_high_card',
    category = { 'jokers', 'golden_wind', 'aerosmith' },
    jokers = { 'j_jojoker_aerosmith' },
    execute = function()
        Balatest.play_hand { 'KS', '2H', '4C', '6D', '8S' }
    end,
    assert = function()
        Balatest.assert_chips(15 * (1 + 4 * G.jokers.cards[1].ability.extra.xmult_mod), "Aerosmith did not give Xmult for 4 unscored cards")
    end
}

Balatest.TestPlay {
    name = 'aerosmith_scales_with_fewer_unscored_cards',
    category = { 'jokers', 'golden_wind', 'aerosmith' },
    jokers = { 'j_jojoker_aerosmith' },
    execute = function()
        Balatest.play_hand { 'KS', '2H', '4C' }
    end,
    assert = function()
        Balatest.assert_chips(15 * (1 + 2 * G.jokers.cards[1].ability.extra.xmult_mod), "Aerosmith did not give Xmult for 2 unscored cards")
    end
}

Balatest.TestPlay {
    name = 'aerosmith_does_nothing_for_single_card_high_card',
    category = { 'jokers', 'golden_wind', 'aerosmith' },
    jokers = { 'j_jojoker_aerosmith' },
    execute = function()
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Aerosmith gave Xmult with no unscored cards")
    end
}

Balatest.TestPlay {
    name = 'aerosmith_does_nothing_for_non_high_card_hand',
    category = { 'jokers', 'golden_wind', 'aerosmith' },
    jokers = { 'j_jojoker_aerosmith' },
    execute = function()
        Balatest.play_hand { 'KS', 'KH', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(60, "Aerosmith gave Xmult for a non High Card hand")
    end
}

--#endregion
--#region Purple Haze

Balatest.TestPlay {
    name = 'purple_haze_infects_a_joker_when_blind_is_selected',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local infected = G.jokers.cards[2]
        Balatest.assert(infected.ability.perishable, "Purple Haze did not make Leaky Eye Luca perishable")
        Balatest.assert_eq(infected.ability.perish_tally, G.GAME.perishable_rounds, "Purple Haze did not start a full perishable countdown")
        Balatest.assert_eq(infected.ability.jojoker_purple_haze_chips, 0, "Infected joker gained chips before it scored")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infects_one_new_joker_each_blind',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[2].ability.perishable and G.jokers.cards[3].ability.perishable, "Purple Haze did not infect a new joker on the second blind")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infected_joker_grows_when_it_scores',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.jokers.cards[2].ability.jojoker_purple_haze_chips, extra.chips_mod, "Infected joker did not gain chips when it scored")
        Balatest.assert_eq(G.jokers.cards[2].ability.jojoker_purple_haze_mult, extra.mult_mod, "Infected joker did not gain mult when it scored")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infected_joker_grows_once_per_hand',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '3H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.jojoker_purple_haze_chips, 2 * G.jokers.cards[1].ability.extra.chips_mod, "Infected joker did not gain chips exactly once per hand")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infected_joker_keeps_growing_after_purple_haze_is_sold',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.jojoker_purple_haze_chips, G.P_CENTERS.j_jojoker_purple_haze.config.extra.chips_mod, "Infected joker stopped growing once Purple Haze was sold")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_does_not_infect_itself_or_incompatible_jokers',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_black_sabbath' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        for _, joker in ipairs(G.jokers.cards) do
            Balatest.assert(not joker.ability.perishable, joker.ability.name.." was made perishable by Purple Haze")
            Balatest.assert(not joker.ability.jojoker_purple_haze_chips, joker.ability.name.." was infected by Purple Haze")
        end
    end
}

Balatest.TestPlay {
    name = 'purple_haze_does_not_infect_eternal_jokers',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze' },
    execute = function()
        Balatest.q(function()
            local eternal = SMODS.add_card { key = 'j_jojoker_leaky_eye_luca' }
            eternal.ability.eternal = true
        end)
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[2].ability.perishable, "Purple Haze made an eternal joker perishable")
        Balatest.assert(not G.jokers.cards[2].ability.jojoker_purple_haze_chips, "Purple Haze infected an eternal joker")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infected_joker_stops_growing_once_it_perishes',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[2].ability.perish_tally = 1
        Balatest.play_hand { '2H' }
        Balatest.next_round()
        Balatest.play_hand { '3H' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[2].debuff, "Infected joker did not perish")
        Balatest.assert_eq(G.jokers.cards[2].ability.jojoker_purple_haze_chips, G.jokers.cards[1].ability.extra.chips_mod, "Perished joker kept growing")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_bonus_scores_with_the_infected_joker',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        -- High Card: (5 + 2 + 10) chips x (1 + 3) mult; Leaky Eye Luca adds nothing without a Spade
        Balatest.assert_chips(68, "Purple Haze bonus was not scored by the infected joker")
    end
}

Balatest.TestPlay {
    name = 'purple_haze_infected_joker_keeps_growing_while_white_album_freezes_it',
    category = { 'jokers', 'golden_wind', 'purple_haze' },
    jokers = { 'j_jojoker_white_album', 'j_jojoker_purple_haze', 'j_jojoker_leaky_eye_luca' },
    execute = function()
        G.jokers.cards[3].ability.perish_tally = 1
        Balatest.play_hand { '2H' }
        Balatest.next_round()
        Balatest.play_hand { '3H' }
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[3].debuff, "White Album did not keep the infected joker from perishing")
        Balatest.assert_eq(G.jokers.cards[3].ability.jojoker_purple_haze_chips, 2 * G.jokers.cards[2].ability.extra.chips_mod, "Frozen infected joker did not keep growing")
    end
}

--#endregion
--#region Talking Head

Balatest.TestPlay {
    name = 'talking_head_duplicates_used_tarot_card',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head' },
    consumeables = { 'c_hermit' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1, "Talking Head did not duplicate the used tarot card")
        Balatest.assert_eq(G.consumeables.cards[1].config.center.key, "c_hermit", "Talking Head did not duplicate the correct tarot card")
    end
}

Balatest.TestPlay {
    name = 'talking_head_duplicates_used_spectral_card',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head' },
    consumeables = { 'c_black_hole' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1, "Talking Head did not duplicate the used spectral card")
        Balatest.assert_eq(G.consumeables.cards[1].config.center.key, "c_black_hole", "Talking Head did not duplicate the correct spectral card")
    end
}

Balatest.TestPlay {
    name = 'talking_head_duplicates_each_used_consumable',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head' },
    consumeables = { 'c_hermit', 'c_mars' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 2, "Talking Head did not duplicate both used consumables")
    end
}

Balatest.TestPlay {
    name = 'talking_head_needs_room_for_the_duplicate',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head' },
    consumeables = { 'c_emperor' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, G.consumeables.config.card_limit, "Talking Head duplicated a consumable without room for it")
    end
}

Balatest.TestPlay {
    name = 'talking_head_does_not_duplicate_with_rolling_stones',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head', 'j_jojoker_rolling_stones' },
    consumeables = { 'c_hermit' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 0, "Talking Head duplicated a consumable while Rolling Stones set every chance to 0")
    end
}

Balatest.TestPlay {
    name = 'talking_head_duplicate_feeds_kiss',
    category = { 'jokers', 'golden_wind', 'talking_head' },
    jokers = { 'j_jojoker_talking_head', 'j_jojoker_kiss' },
    consumeables = { 'c_hermit' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.extra.chips, G.jokers.cards[2].ability.extra.chips_mod, "Kiss did not gain chips when Talking Head duplicated a consumable")
    end
}

--#endregion
--#region Metallica

Balatest.TestPlay {
    name = 'metallica_gains_xmult_for_each_scored_steel_card',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '2', s = 'C', e = 'm_steel' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_xmult = 1 + G.jokers.cards[1].ability.extra.Xmult_mod * 2
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Metallica xmult wasn't "..expected_xmult.." after scoring two steel cards")
    end
}

Balatest.TestPlay {
    name = 'metallica_gains_xmult_for_scored_gold_card',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_gold' },
        { r = '2', s = 'C' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_xmult = 1 + G.jokers.cards[1].ability.extra.Xmult_mod
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Metallica xmult wasn't "..expected_xmult.." after scoring one gold card")
    end
}

Balatest.TestPlay {
    name = 'metallica_gains_xmult_for_mixed_steel_and_gold_cards',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '2', s = 'C', e = 'm_gold' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_xmult = 1 + G.jokers.cards[1].ability.extra.Xmult_mod * 2
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Metallica xmult wasn't "..expected_xmult.." after scoring a steel and a gold card")
    end
}

Balatest.TestPlay {
    name = 'metallica_accumulates_across_hands',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '4', s = 'C', e = 'm_gold' },
        { r = '3', s = 'H' } } },
    hand_size = 3,
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '4C' }
    end,
    assert = function()
        local xmult_mod = G.jokers.cards[1].ability.extra.Xmult_mod
        local expected_xmult = 1 + xmult_mod + xmult_mod
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Metallica xmult wasn't "..expected_xmult.." after two hands with one metal card each")
    end
}

Balatest.TestPlay {
    name = 'metallica_ignores_unscored_steel_and_gold_cards',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '2', s = 'C' },
        { r = '9', s = 'H', e = 'm_steel' },
        { r = '8', s = 'D', e = 'm_gold' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '9H', '8D' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Metallica gained xmult from unscored steel or gold cards")
    end
}

Balatest.TestPlay {
    name = 'metallica_applies_xmult_when_scoring',
    category = { 'jokers', 'golden_wind', 'metallica' },
    jokers = { 'j_jojoker_metallica' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '2', s = 'C' },
        { r = '3', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.Xmult = 2
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        -- Pair of 2s: (10 + 2 + 2) chips * 2 mult * X2
        Balatest.assert_chips(56, "Metallica did not apply its Xmult during scoring")
    end
}

--#endregion
