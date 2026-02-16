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