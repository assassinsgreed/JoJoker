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