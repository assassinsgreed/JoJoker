--#region Goo Goo Dolls

Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_no_mult_at_starting_deck_size',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Goo Goo Dolls gave mult with a full starting deck")
    end
}

Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_mult_for_each_destroyed_card',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    consumeables = { 'c_hanged_man' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '3', s = 'C' },
        { r = '5', s = 'H' },
        { r = '7', s = 'D' },
        { r = '9', s = 'S' } } },
    execute = function()
        Balatest.highlight { '3C', '5H' }
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(get_goo_goo_dolls_mult(G.jokers.cards[1]), G.jokers.cards[1].ability.extra.mult * 2, "Goo Goo Dolls did not count both destroyed cards")
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult * 2 + 1), "Goo Goo Dolls did not give mult for each card below starting deck size")
    end
}

Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_no_mult_when_deck_exceeds_starting_size',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        local copy = copy_card(G.hand.cards[1], nil, nil, G.playing_card)
        copy:add_to_deck()
        G.deck.config.card_limit = G.deck.config.card_limit + 1
        table.insert(G.playing_cards, copy)
        G.deck:emplace(copy)
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Goo Goo Dolls gave mult when deck was larger than starting size")
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

Balatest.TestPlay {
    name = 'made_in_heaven_xmult_floors_at_one_when_nothing_is_lost',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 1,
    discards = 0,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "Made in Heaven Xmult dropped below X1 when no hands or discards were lost")
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
        Balatest.assert_eq(ff_chips, G.jokers.cards[1].ability.extra.chips_mod * 2, "Foo Fighters did not give chips for each unique played card this blind.")
    end
}

Balatest.TestPlay {
    name = 'foo_fighters_does_not_give_extra_chips_for_duplicate_played_card_this_ante',
    category = { 'jokers', 'stone_ocean', 'foo_fighters' },
    jokers = { 'j_jojoker_foo_fighters' },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
        Balatest.next_round()
        Balatest.play_hand { '2C', '3C' }
    end,
    assert = function()
        local ff_chips = G.jokers.cards[1].ability.extra.chips
        Balatest.assert_eq(ff_chips, G.jokers.cards[1].ability.extra.chips_mod * 3, "Foo Fighters did not give chips for each unique played card this ante.")
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
--#region Limp Bizkit

Balatest.TestPlay {
    name = 'limp_bizkit_creates_negative_joker_when_triggered',
    category = { 'jokers', 'stone_ocean', 'limp_bizkit' },
    jokers = { 'j_jojoker_death_thirteen', 'j_jojoker_josuke_higashikata_jjl', 'j_jojoker_limp_bizkit' },
    hands = 1,
    execute = function()
        G.jokers.cards[1], G.jokers.cards[2] = G.jokers.cards[2], G.jokers.cards[1] -- Swap order so Death Thirteen doesn't destroy Josuke before we can maninpulate the numerator
        G.jokers.cards[3].ability.extra.denominator = G.jokers.cards[3].ability.extra.numerator
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 3, "Limp Bizkit did not create negative joker correctly")
        Balatest.assert_eq(G.jokers.cards[3].edition.key, "e_negative", "Limp Bizkit did not recreate destroyed joker as Negative")
        Balatest.assert_eq(G.jokers.cards[3].config.center.key, "j_jojoker_josuke_higashikata_jjl", "Limp Bizkit did not recreate the expected joker")
    end
}

--#endregion
--#region Marilyn Manson

Balatest.TestPlay {
    name = 'marilyn_manson_gives_money_when_no_discards_remain',
    category = { 'jokers', 'stone_ocean', 'marilyn_manson' },
    jokers = { 'j_jojoker_marilyn_manson' },
    dollars = 0,
    discards = 0,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.debt_repay, "Marilyn Manson did not give money for repaid debt when no discards remained")
    end
}

Balatest.TestPlay {
    name = 'marilyn_manson_allows_player_to_go_into_debt',
    category = { 'jokers', 'stone_ocean', 'marilyn_manson' },
    jokers = { 'j_jojoker_marilyn_manson' },
    dollars = 0,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
    end,
    assert = function()
        local in_debt = G.GAME.dollars < 0
        Balatest.assert(in_debt, "Marilyn Manson did not let the player go into debt")
        Balatest.assert_eq(G.GAME.bankrupt_at, -G.jokers.cards[1].ability.extra.debt, "Marilyn Manson did not set the correct bankruptcy threshold when allowing the player to go into debt")
    end
}

--#endregion
--#region C-Moon

Balatest.TestPlay {
    name = 'c_moon_equalizes_chips_and_mult',
    category = { 'jokers', 'stone_ocean', 'c_moon' },
    jokers = { 'j_jojoker_c_moon' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '4D', '4H' }
    end,
    assert = function()
        Balatest.assert_chips(289, "C-Moon did not equalize chips and mult")
    end
}

--#endregion
--#region Planet Waves

Balatest.TestPlay {
    name = 'planet_waves_duplicates_planet_card',
    category = { 'jokers', 'stone_ocean', 'planet_waves' },
    jokers = { 'j_jojoker_planet_waves' },
    consumeables = { 'c_mars' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1, "Planet Waves did not duplicate any planet cards")
        Balatest.assert_eq(G.consumeables.cards[1].config.center.key, "c_mars", "Planet Waves did not duplicate the correct planet card")
    end
}

--#endregion
--#region Kiss

Balatest.TestPlay {
    name = 'kiss_gains_chips_when_a_playing_card_is_duplicated',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss', 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, G.jokers.cards[1].ability.extra.chips_mod, "Kiss did not gain chips when German Engineering duplicated a played card")
    end
}

Balatest.TestPlay {
    name = 'kiss_gains_chips_for_each_copy_made',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss' },
    consumeables = { 'c_cryptid' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '3', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, G.jokers.cards[1].ability.extra.chips_mod * 2, "Kiss did not gain chips for each copy Cryptid created")
    end
}

Balatest.TestPlay {
    name = 'kiss_gains_chips_when_a_consumable_is_duplicated',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss', 'j_jojoker_planet_waves' },
    consumeables = { 'c_mars' },
    execute = function()
        G.jokers.cards[2].ability.extra.denominator = G.jokers.cards[2].ability.extra.numerator
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, G.jokers.cards[1].ability.extra.chips_mod, "Kiss did not gain chips when Planet Waves duplicated a planet card")
    end
}

Balatest.TestPlay {
    name = 'kiss_does_not_gain_chips_when_a_card_is_converted',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss' },
    consumeables = { 'c_death' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '3', s = 'C' },
        { r = '5', s = 'H' } } },
    execute = function()
        Balatest.highlight { '2S', '3C' }
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, 0, "Kiss gained chips when Death converted a card instead of duplicating one")
    end
}

Balatest.TestPlay {
    name = 'kiss_gives_its_accumulated_chips_when_a_hand_is_scored',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss' },
    execute = function()
        G.jokers.cards[1].ability.extra.chips = G.jokers.cards[1].ability.extra.chips_mod
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(37, "Kiss did not give its accumulated chips when a hand was scored")
    end
}

--#endregion
--#region Jumpin' Jack Flash

Balatest.TestPlay {
    name = 'jumpin_jack_flash_retriggers_scoring_jack',
    category = { 'jokers', 'stone_ocean', 'jumpin_jack_flash' },
    jokers = { 'j_jojoker_jumpin_jack_flash' },
    execute = function()
        Balatest.play_hand { 'JS' }
    end,
    assert = function()
        Balatest.assert_chips(35, "Jumpin' Jack Flash did not retrigger a scoring Jack twice")
    end
}

Balatest.TestPlay {
    name = 'jumpin_jack_flash_retriggers_each_scoring_jack',
    category = { 'jokers', 'stone_ocean', 'jumpin_jack_flash' },
    jokers = { 'j_jojoker_jumpin_jack_flash' },
    execute = function()
        Balatest.play_hand { 'JS', 'JH' }
    end,
    assert = function()
        Balatest.assert_chips(140, "Jumpin' Jack Flash did not retrigger every scoring Jack")
    end
}

Balatest.TestPlay {
    name = 'jumpin_jack_flash_does_not_retrigger_other_ranks',
    category = { 'jokers', 'stone_ocean', 'jumpin_jack_flash' },
    jokers = { 'j_jojoker_jumpin_jack_flash' },
    execute = function()
        Balatest.play_hand { 'QS' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Jumpin' Jack Flash retriggered a card that was not a Jack")
    end
}

Balatest.TestPlay {
    name = 'jumpin_jack_flash_does_not_retrigger_unscored_jack',
    category = { 'jokers', 'stone_ocean', 'jumpin_jack_flash' },
    jokers = { 'j_jojoker_jumpin_jack_flash' },
    execute = function()
        Balatest.play_hand { 'KS', 'JS' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Jumpin' Jack Flash retriggered a Jack that did not score")
    end
}
--#endregion

--#region Under World
Balatest.TestPlay {
    name = 'under_world_doubles_a_rank_scored_earlier_this_round',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(7 + (5 + 2 * 2), "Under World did not double the chips of a rank scored in an earlier hand")
    end
}

Balatest.TestPlay {
    name = 'under_world_compounds_for_each_earlier_hand_with_the_rank',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    hands = 5,
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'AH' }
        Balatest.play_hand { 'AC' }
        Balatest.play_hand { 'AD' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.rank_hands[14], 4, "Under World did not count each hand that scored an Ace")
        Balatest.assert_chips((5 + 11) + (5 + 11 * 2) + (5 + 11 * 4) + (5 + 11 * 8), "Under World did not compound X2 rank chips for each earlier hand with Aces")
    end
}

Balatest.TestPlay {
    name = 'under_world_doubles_every_scoring_card_of_the_rank',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        Balatest.play_hand { 'AS', 'AH' }
        Balatest.play_hand { 'AC', 'AD' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.rank_hands[14], 2, "Under World counted a Pair of Aces as more than one hand")
        Balatest.assert_chips((10 + 22) * 2 + (10 + 44) * 2, "Under World did not double each scoring Ace")
    end
}

Balatest.TestPlay {
    name = 'under_world_tracks_every_rank_in_a_hand',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        keep_blind_unbeaten()
        Balatest.play_hand { 'AS', 'AH', '2S', '2H', '2C' }
        Balatest.play_hand { 'AC' }
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        Balatest.assert_chips((40 + 22 + 6) * 4 + (5 + 22) + (5 + 4), "Under World did not double both ranks from a Full House")
    end
}

Balatest.TestPlay {
    name = 'under_world_ignores_ranks_that_did_not_score',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        Balatest.play_hand { '2S', '2H', 'KS' }
        Balatest.play_hand { 'KH' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.rank_hands[2], 1, "Under World did not count the scored Pair of 2s")
        Balatest.assert_chips(28 + 15, "Under World counted an unscored King kicker toward its rank")
    end
}

Balatest.TestPlay {
    name = 'under_world_keeps_ranks_between_rounds_of_an_ante',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.rank_hands[14], 1, "Under World forgot its rank tally before the ante ended")
    end
}

Balatest.TestPlay {
    name = 'under_world_forgets_ranks_when_the_ante_ends',
    category = { 'jokers', 'stone_ocean', 'under_world' },
    jokers = { 'j_jojoker_under_world' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.q(function() ease_ante(1) end)
    end,
    assert = function()
        Balatest.assert_eq(next(G.jokers.cards[1].ability.extra.rank_hands), nil, "Under World kept its rank tally after the ante ended")
    end
}
--#endregion

--#region Jailhouse Lock

Balatest.TestPlay {
    name = 'jailhouse_lock_does_not_level_up_a_hand_type_the_first_time_it_is_played',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1, "Jailhouse Lock leveled up High Card the first time it was played")
        Balatest.assert_chips((5 + 11) * 1, "Jailhouse Lock changed the score of a first-time High Card")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_levels_up_a_replayed_hand_type_before_three_types_are_played',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'AH' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1 + G.jokers.cards[1].ability.extra.levels, "Jailhouse Lock did not level up a replayed High Card before 3 hand types were played")
        Balatest.assert_chips((5 + 11) * 1 + (5 + 10 * 2 + 11) * (1 + 1 * 2), "Jailhouse Lock did not score the replayed High Card with its new levels")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_scores_and_levels_up_a_locked_hand_type',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        G.GAME.jojoker_recent_hand_types = { 'Flush', 'Straight', 'Pair' }
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands['Pair'].level, 1 + G.jokers.cards[1].ability.extra.levels, "Jailhouse Lock did not level up a locked Pair")
        Balatest.assert_chips((10 + 15 * 2 + 2 + 2) * (2 + 1 * 2), "Jailhouse Lock did not score a locked Pair")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_debuffs_a_hand_type_outside_the_last_three',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        G.GAME.jojoker_recent_hand_types = { 'Pair', 'Flush', 'Straight' }
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 1, "Jailhouse Lock leveled up a hand type it debuffed")
        Balatest.assert_chips(0, "Jailhouse Lock did not debuff a hand type outside the last 3")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_rotates_a_debuffed_hand_type_into_the_lock',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        G.GAME.jojoker_recent_hand_types = { 'Pair', 'Flush', 'Straight' }
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'AH' }
    end,
    assert = function()
        Balatest.assert_eq(table.concat(get_jailhouse_locked_hands(G.jokers.cards[1].ability.extra.hand_types), ', '), 'Flush, Straight, High Card', "Jailhouse Lock did not drop the oldest hand type when a new one was played")
        Balatest.assert_chips((5 + 10 * 2 + 11) * (1 + 1 * 2), "Jailhouse Lock did not score High Card once it rotated into the lock")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_replaying_a_locked_type_makes_it_the_most_recent',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    jokers = { 'j_jojoker_jailhouse_lock' },
    execute = function()
        G.GAME.jojoker_recent_hand_types = { 'Pair', 'Flush', 'Straight' }
        Balatest.play_hand { '2S', '2H' }
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(table.concat(get_jailhouse_locked_hands(G.jokers.cards[1].ability.extra.hand_types), ', '), 'Straight, Pair, High Card', "Jailhouse Lock dropped a hand type that was replayed recently")
    end
}

Balatest.TestPlay {
    name = 'jailhouse_lock_tracks_hand_types_played_before_it_was_owned',
    category = { 'jokers', 'stone_ocean', 'jailhouse_lock' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_eq(table.concat(G.GAME.jojoker_recent_hand_types, ', '), 'High Card, Pair', "Hand types were not tracked without Jailhouse Lock owned")
    end
}
--#endregion

--#region Weather Report
Balatest.TestPlay {
    name = 'weather_report_heavy_weather_turns_other_jokers_into_snails',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', 'j_jojoker_kiss', 'j_jojoker_dios_bone' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].config.center.key, 'j_jojoker_weather_report', "Weather Report turned itself into a Snail")
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_snail', "Heavy Weather did not turn Kiss into a Snail")
        Balatest.assert_eq(G.jokers.cards[3].config.center.key, 'j_jojoker_snail', "Heavy Weather did not turn DIO's Bone into a Snail")
    end
}

Balatest.TestPlay {
    name = 'weather_report_heavy_weather_turns_other_weather_reports_into_snails',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', 'j_jojoker_weather_report' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].config.center.key, 'j_jojoker_weather_report', "The first Weather Report did not survive Heavy Weather")
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_snail', "Heavy Weather did not turn the other Weather Report into a Snail")
    end
}

Balatest.TestPlay {
    name = 'weather_report_heavy_weather_keeps_eternal_stickers',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', { id = 'j_jojoker_kiss', eternal = true } },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_snail', "Heavy Weather did not turn an Eternal joker into a Snail")
        Balatest.assert(G.jokers.cards[2].ability.eternal, "Heavy Weather dropped the Eternal sticker")
    end
}

Balatest.TestPlay {
    name = 'weather_report_heavy_weather_skips_snails_so_they_keep_their_chips',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', 'j_jojoker_snail' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        G.jokers.cards[2].ability.extra.chips = 100
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].ability.extra.chips, 100, "Heavy Weather reset an existing Snail's chips")
    end
}

Balatest.TestPlay {
    name = 'weather_report_leaves_jokers_alone_when_heavy_weather_misses',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', 'j_jojoker_kiss' },
    execute = function()
        G.jokers.cards[1].ability.extra.numerator = 0
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_kiss', "Weather Report converted a joker without Heavy Weather triggering")
    end
}

Balatest.TestPlay {
    name = 'weather_report_gives_compounding_xmult_per_snail',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report', 'j_jojoker_snail', 'j_jojoker_snail' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local snail_chips = G.jokers.cards[2].ability.extra.chips_mod + G.jokers.cards[3].ability.extra.chips_mod
        Balatest.assert_chips(math.floor((7 + snail_chips) * G.jokers.cards[1].ability.extra.Xmult ^ 2), "Weather Report did not give X1.5 for each Snail")
    end
}

Balatest.TestPlay {
    name = 'weather_report_gives_no_xmult_without_snails',
    category = { 'jokers', 'stone_ocean', 'weather_report' },
    jokers = { 'j_jojoker_weather_report' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Weather Report gave Xmult without any Snails")
    end
}
--#endregion

--#region Diver Down
Balatest.TestPlay {
    name = 'diver_down_turns_every_scored_card_into_one_rank_and_suit',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    execute = function()
        Balatest.play_hand { '2S', '3H', '4C', '5D', '6S' }
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(count_distinct_bases(G.discard.cards), 1, "Diver Down did not give every scored card the same rank and suit")
    end
}

Balatest.TestPlay {
    name = 'diver_down_leaves_unscored_played_cards_alone',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    execute = function()
        Balatest.play_hand { '4S', '4H', '9C' }
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(count_playing_cards('9', 'Clubs'), 1, "Diver Down converted a played card that did not score")
        Balatest.assert_eq(count_distinct_bases(G.discard.cards), 2, "Diver Down did not give both scored 4s the same suit")
    end
}

Balatest.TestPlay {
    name = 'diver_down_skips_stone_cards',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    deck = { cards = {
        { r = '4', s = 'S' }, { r = '4', s = 'H' }, { r = 'K', s = 'C', e = 'm_stone' },
        { r = '2', s = 'D' }, { r = '2', s = 'D' }, { r = '2', s = 'D' } } },
    hand_size = 6,
    execute = function()
        Balatest.play_hand { '4S', '4H', 'KC' }
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(count_playing_cards('King', 'Clubs'), 1, "Diver Down picked or converted a Stone card")
        Balatest.assert_eq(count_distinct_bases(G.discard.cards), 2, "Diver Down did not convert the 4s around the Stone card")
    end
}

Balatest.TestPlay {
    name = 'diver_down_does_nothing_when_only_stone_cards_score',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    deck = { cards = {
        { r = 'K', s = 'C', e = 'm_stone' }, { r = 'Q', s = 'H', e = 'm_stone' },
        { r = '2', s = 'D' }, { r = '2', s = 'D' } } },
    hand_size = 4,
    execute = function()
        Balatest.play_hand { 'KC', 'QH' }
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(count_playing_cards('King', 'Clubs'), 1, "Diver Down converted a Stone card")
        Balatest.assert_eq(count_playing_cards('Queen', 'Hearts'), 1, "Diver Down converted a Stone card")
    end
}

Balatest.TestPlay {
    name = 'diver_down_skips_cards_destroyed_during_scoring',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    deck = { cards = {
        { r = '4', s = 'S', e = 'm_glass' }, { r = '4', s = 'H', e = 'm_glass' },
        { r = '2', s = 'D' }, { r = '2', s = 'D' } } },
    hand_size = 4,
    execute = function()
        restore_pseudorandom = force_pseudorandom_roll('glass', 0)
        Balatest.play_hand { '4S', '4H' }
        Balatest.wait()
    end,
    assert = function()
        restore_pseudorandom()
        Balatest.assert_eq(#G.playing_cards, 2, "Both shattered Glass cards should be gone from the deck")
        Balatest.assert_eq(count_playing_cards('2', 'Diamonds'), 2, "Diver Down converted cards outside the scored hand")
    end
}

Balatest.TestPlay {
    name = 'diver_down_converts_only_after_the_hand_scores',
    category = { 'jokers', 'stone_ocean', 'diver_down' },
    jokers = { 'j_jojoker_diver_down' },
    execute = function()
        Balatest.play_hand { '2S', '5S', '7S', '9S', 'KS' }
    end,
    assert = function()
        -- Flush: (35 + 2 + 5 + 7 + 9 + 10) chips * 4 mult
        Balatest.assert_chips(272, "Diver Down changed the cards before the hand finished scoring")
    end
}
--#endregion
