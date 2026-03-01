--#region Goo Goo Dolls
Balatest.TestPlay {
    name = 'goo_goo_dolls_does_not_give_mult_for_incorrect_card_ranks',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '10H' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Goo Goo Dolls gave mult for a card rank outside of 2-6")
    end
}
Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_mult_for_cards_within_rank_2_to_6',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '4S', '4C' }
    end,
    assert = function()
        Balatest.assert_chips(18 * (G.jokers.cards[1].ability.extra.mult * 2 + 2), "Goo Goo Dolls did not give mult for each scored low card")
    end
}
Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_mult_only_for_scored_cards',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '4S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(9 * (G.jokers.cards[1].ability.extra.mult + 1), "Goo Goo Dolls did not give mult for only scored low card")
    end
}
--#endregion

--#region Stone Free
Balatest.TestPlay {
    name = 'stone_free_retriggers_each_stone_card_when_played',
    category = { 'jokers', 'stone_ocean', 'stone_free' },
    jokers = { 'j_jojoker_stone_free' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(205, "Stone Free did not retrigger each stone card when played")
    end
}
--#endregion
--#region Made in Heaven
Balatest.TestPlay {
    name = 'made_in_heaven_reduces_hands_and_discards',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, G.jokers.cards[1].ability.extra.hands, "Made in Heaven did not reduce hands")
        Balatest.assert_eq(G.GAME.current_round.discards_left, G.jokers.cards[1].ability.extra.discards, "Made in Heaven did not reduce discards")
    end
}
Balatest.TestPlay {
    name = 'made_in_heaven_sets_xmult_to_total_lost_hands_and_discards',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 6, "Made in Heaven did not gain XMult for each lost hand and discard")
    end
}
Balatest.TestPlay {
    name = 'made_in_heaven_sets_hand_size_to_deck_size',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52, "Made in Heaven did not set hand size to deck size")
    end
}
--#endregion
--#region Dragon's Dream
Balatest.TestPlay {
    name = 'dragons_dream_randomly_gains_or_loses_values_on_hand_played',
    category = { 'jokers', 'stone_ocean', 'dragons_dream' },
    jokers = { 'j_jojoker_dragons_dream' },
    execute = function()
        Original_chips = G.jokers.cards[1].ability.extra.curr_chips
        Original_mult = G.jokers.cards[1].ability.extra.curr_mult
        Original_money = G.jokers.cards[1].ability.extra.curr_money
        Original_xmult = G.jokers.cards[1].ability.extra.curr_Xmult

        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local valuesChanged = Original_chips ~= G.jokers.cards[1].ability.extra.curr_chips or
            Original_mult ~= G.jokers.cards[1].ability.extra.curr_mult or
            Original_money ~= G.jokers.cards[1].ability.extra.curr_money or
            Original_xmult ~= G.jokers.cards[1].ability.extra.curr_Xmult

        Balatest.assert_eq(valuesChanged, true, "Dragon's Dream did not change any values on hand played")
    end
}
--#endregion
--#region Green Green Grass of Home
Balatest.TestPlay {
    name = 'green_green_grass_of_home_doubles_high_card_chips',
    category = { 'jokers', 'stone_ocean', 'green_green_grass_of_home' },
    jokers = { 'j_jojoker_green_green_grass_of_home' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(18, "Green, Green Grass of Home didn't double chips on scored High Card hand.")
    end
}
Balatest.TestPlay {
    name = 'green_green_grass_of_home_does_not_double_chips_on_non_high_card_hand',
    category = { 'jokers', 'stone_ocean', 'green_green_grass_of_home' },
    jokers = { 'j_jojoker_green_green_grass_of_home' },
    execute = function()
        Balatest.play_hand { '9S', '9D' }
    end,
    assert = function()
        Balatest.assert_chips(56, "Green, Green Grass of Home doubled chips on non-High Card hand.")
    end
}
--#endregion
--#region Survivor
Balatest.TestPlay {
    name = 'survivor_causes_all_played_cards_to_be_scored',
    category = { 'jokers', 'stone_ocean', 'survivor' },
    jokers = { 'j_jojoker_survivor' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(10, "Survivor did not cause all played cards to be scored.")
    end
}
--#endregion
--#region Foo Fighters
Balatest.TestPlay {
    name = 'foo_fighters_gives_chips_for_each_unique_played_card_this_blind',
    category = { 'jokers', 'stone_ocean', 'foo_fighters' },
    jokers = { 'j_jojoker_foo_fighters' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        local ff_chips = G.jokers.cards[1].ability.extra.chips
        Balatest.assert_eq(ff_chips, 4, "Foo Fighters did not give chips for each unique played card this blind.")
    end
}
Balatest.TestPlay {
    name = 'foo_fighters_gives_chips_for_each_unique_played_card_this_ante',
    category = { 'jokers', 'stone_ocean', 'foo_fighters' },
    jokers = { 'j_jojoker_foo_fighters' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
        Balatest.next_round()
        Balatest.play_hand { '2C', '3C' }
    end,
    assert = function()
        local ff_chips = G.jokers.cards[1].ability.extra.chips
        Balatest.assert_eq(ff_chips, 6, "Foo Fighters did not give chips for each unique played card this ante.")
    end
}
-- Can't mainuplate antes through Balatest
--#endregion
--#region White Snake
Balatest.TestPlay {
    name = 'white_snake_gives_polychrome_enhancement_to_scored_card_without_enhancement',
    category = { 'jokers', 'stone_ocean', 'white_snake' },
    jokers = { 'j_jojoker_white_snake' },
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
        local queenenhancement = G.deck.cards[1].config.center
        Balatest.assert_eq(queenenhancement, G.P_CENTERS.m_wild, "White Snake didn't give wild enhancement to scored card with no other enhancements")
    end
}

Balatest.TestPlay {
    name = 'white_snake_gives_wild_enhancement_to_multiple_scored_cards_without_enhancement',
    category = { 'jokers', 'stone_ocean', 'white_snake' },
    jokers = { 'j_jojoker_white_snake' },
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
        local queenenhancement1 = G.deck.cards[1].config.center
        local queenenhancement2 = G.deck.cards[2].config.center
        Balatest.assert_eq(queenenhancement1, G.P_CENTERS.m_wild, "White Snake didn't give wild enhancement to scored card with no other enhancements")
        Balatest.assert_eq(queenenhancement2, G.P_CENTERS.m_wild, "White Snake didn't give wild enhancement to scored card with no other enhancements")
    end
}

Balatest.TestPlay {
    name = 'white_snake_does_not_give_wild_enhancement_to_card_with_an_existing_enhancement',
    category = { 'jokers', 'stone_ocean', 'white_snake' },
    jokers = { 'j_jojoker_white_snake' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 1
        G.jokers.cards[1].ability.extra.denominator = 1
        G.hand.cards[1]:set_ability(G.P_CENTERS.m_mult, nil, true)
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queenenhancement1 = G.deck.cards[1].config.center
        Balatest.assert_eq(queenenhancement1, G.P_CENTERS.m_mult, "White Snake incorrectly gave wild enhancement to card with existing enhancement")
    end
}
--#endregion
--#region Burning Down the House
Balatest.TestPlay {
    name = 'burning_down_the_house_saves_failed_run_and_is_destroyed',
    category = { 'jokers', 'stone_ocean', 'burning_down_the_house' },
    jokers = { 'j_jojoker_burning_down_the_house' },
    hands = 1,
    execute = function()
        Balatest.play_hand { 'QS' }
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0, "Burning Down the House was not destroyed after saving failed run")
        -- If the run was not saved, this assertion could not run
    end
}
--#endregion