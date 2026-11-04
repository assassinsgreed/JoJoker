--#region Soft & Wet

Balatest.TestPlay {
    name = 'soft_and_wet_gains_no_mult_when_no_enhancements_scored',
    category = { 'jokers', 'jojolion', 'soft_and_wet' },
    jokers = { 'j_jojoker_soft_and_wet' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Soft & Wet incorrectly gained mult when scoring non-enhanced cards")
    end
}

Balatest.TestPlay {
    name = 'soft_and_wet_gains_mult_for_each_enhanced_card_scored',
    category = { 'jokers', 'jojolion', 'soft_and_wet' },
    jokers = { 'j_jojoker_soft_and_wet' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_lucky' },
        { r = '2', s = 'H', e = 'm_glass' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, G.jokers.cards[1].ability.extra.mult_mod * 3, "Soft & Wet did not gain expected mult when removing enhancements from 3 cards")
    end
}

Balatest.TestPlay {
    name = 'soft_and_wet_removes_enhancements_from_scored_cards',
    category = { 'jokers', 'jojolion', 'soft_and_wet' },
    jokers = { 'j_jojoker_soft_and_wet' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '3', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local anyEnhanced = false
        for _, card in ipairs(G.deck.cards) do
            if card.config.center ~= G.P_CENTERS.c_base then anyEnhanced = true end
        end
        Balatest.assert(not anyEnhanced, "Cards in deck should not have enhancements")
    end
}

--#endregion
--#region Paper Moon King

Balatest.TestPlay {
    name = 'paper_moon_king_enables_pareidolia',
    category = { 'jokers', 'jojolion', 'paper_moon_king' },
    jokers = { 'j_jojoker_paper_moon_king', 'j_jojoker_yellow_temperance' }, -- Tested with yellow temperance to ensure cards are considered face cards
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Paper Moon King did not see played 2 as a face card")
    end
}

--#endregion
--#region Milagro Man

Balatest.TestPlay {
    name = 'milagro_man_doubles_earned_interest',
    category = { 'jokers', 'jojolion', 'milagro_man' },
    jokers = { 'j_jojoker_milagro_man' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_dollars(12, "Milagro Man did not double earned interest") -- 10 / 5 + starting money
    end
}

--#endregion
--#region I Am A Rock

Balatest.TestPlay {
    name = 'i_am_a_rock_adds_stone_enhancement_to_unenhanced_and_unscored_cards',
    category = { 'jokers', 'jojolion', 'i_am_a_rock' },
    jokers = { 'j_jojoker_i_am_a_rock' },
    deck = { cards = {
        { r = '2', s = 'C' },
        { r = '3', s = 'C' },
        { r = '4', s = 'C' },
        { r = '5', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2C', '3C', '4C' }
        Balatest.end_round() -- To check deck contents
    end,
    assert = function()
        local isTwoStone = G.deck.cards[1].config.center == G.P_CENTERS.m_stone
        local isThreeStone = G.deck.cards[2].config.center == G.P_CENTERS.m_stone
        local isFourStone = G.deck.cards[3].config.center == G.P_CENTERS.m_stone
        local isFiveStone = G.deck.cards[4].config.center == G.P_CENTERS.m_stone
        Balatest.assert(isTwoStone and isThreeStone and not isFourStone and not isFiveStone, "I Am A Rock did not convert unscored 2 and 3 to stone cards")
    end
}

Balatest.TestPlay {
    name = 'i_am_a_rock_does_not_enhance_unscored_cards_with_enhancements',
    category = { 'jokers', 'jojolion', 'i_am_a_rock' },
    jokers = { 'j_jojoker_i_am_a_rock' },
    deck = { cards = {
        { r = '2', s = 'C', e = 'm_lucky' },
        { r = '3', s = 'C' },
        { r = '4', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2C', '3C' }
        Balatest.end_round() -- To check deck contents
    end,
    assert = function()
        local isTwoStone = G.deck.cards[1].config.center == G.P_CENTERS.m_stone
        Balatest.assert(not isTwoStone, "I Am A Rock converted unscored 2 with an existing enhancement")
    end
}

--#endregion
--#region California King Bed

Balatest.TestPlay {
    name = 'california_king_bed_adds_xmult_before_scoring',
    category = { 'jokers', 'jojolion', 'california_king_bed' },
    jokers = { 'j_jojoker_california_king_bed' },
    execute = function()
        Balatest.play_hand { '2C', '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(162, "California King Bed did not add mult before scoring")
    end
}

Balatest.TestPlay {
    name = 'california_king_bed_adds_xmult_for_each_unique_hand',
    category = { 'jokers', 'jojolion', 'california_king_bed' },
    jokers = { 'j_jojoker_california_king_bed' },
    execute = function()
        Balatest.play_hand { '2C' }
        Balatest.play_hand { '2D' }
        Balatest.play_hand { '3C', '3H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + 2 * G.jokers.cards[1].ability.extra.Xmult_mod, "California King Bed did not earn XMult for two unique hand types")
    end
}

Balatest.TestPlay {
    name = 'california_king_bed_resets_xmult_at_end_of_round',
    category = { 'jokers', 'jojolion', 'california_king_bed' },
    jokers = { 'j_jojoker_california_king_bed' },
    execute = function()
        G.jokers.cards[1].ability.extra.XMult = 3
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "California King Bed did not reset XMult at end of round")
    end
}

--#endregion
--#region Doctor Wu

Balatest.TestPlay {
    name = 'doctor_wu_adds_stone_card_to_deck_at_start_of_blinds',
    category = { 'jokers', 'jojolion', 'doctor_wu' },
    jokers = { 'j_jojoker_doctor_wu' },
    execute = function()
        Balatest.end_round() -- To get cards back into the deck
    end,
    assert = function()
        local hasStoneCard = false
        for _, card in pairs(G.deck.cards) do
            if card.config.center == G.P_CENTERS.m_stone then hasStoneCard = true end
        end
        Balatest.assert(hasStoneCard, "Doctor Wu did not add a stone card to the deck at the start of blinds")
    end
}

--#endregion
--#region Wonder of U

Balatest.TestPlay {
    name = 'wonder_of_u_destroys_all_other_jokers_including_eternal_and_gains_xmult_for_each',
    category = { 'jokers', 'jojolion', 'wonder_of_u' },
    jokers = { 'j_jojoker_wonder_of_u', 'j_jojoker_soft_and_wet', 'j_jojoker_josuke_higashikata_jjl' },
    execute = function()
        G.jokers.cards[3].ability.eternal = true
        G.jokers.cards[1].ability.extra.rounds_left = 1
        Balatest.end_round() -- To trigger end of round destruction and check for XMult gain
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Wonder of U did not destroy all other jokers (including eternal)")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + 2 * G.jokers.cards[1].ability.extra.Xmult_mod, "Wonder of U did not gain XMult for each destroyed joker")
    end
}

--#endregion
--#region Paisley Park

Balatest.TestPlay {
    name = 'paisley_park_increases_booster_pack_count_in_shop',
    category = { 'jokers', 'jojolion', 'paisley_park' },
    jokers = { 'j_jojoker_paisley_park' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(#G.shop_booster.cards, 3, "Paisley Park did not increase available booster pack count")
    end
}
-- No test for increased booster pack contents; the options presented are random

--#endregion
--#region Space Trucking

Balatest.TestPlay {
    name = 'space_trucking_makes_held_consumeables_negative',
    category = { 'jokers', 'jojolion', 'space_trucking' },
    jokers = { 'j_jojoker_space_trucking' },
    consumeables = { 'c_mars' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.cards[1].edition.negative, true, "Space Trucking did not make held consumeables negative")
    end
}

Balatest.TestPlay {
    name = 'space_trucking_affects_consumeables_with_existing_editions',
    category = { 'jokers', 'jojolion', 'space_trucking' },
    jokers = { 'j_jojoker_space_trucking' },
    consumeables = { 'c_mars' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        G.consumeables.cards[1]:set_edition("e_foil")
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.cards[1].edition.negative, true, "Space Trucking did not make a held consumeable with an existing edition negative")
    end
}

Balatest.TestPlay {
    name = 'space_trucking_makes_only_one_consumeable_negative_per_shop',
    category = { 'jokers', 'jojolion', 'space_trucking' },
    jokers = { 'j_jojoker_space_trucking' },
    consumeables = { 'c_mars', 'c_venus' },
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        local negatives = 0
        for _, consumeable in ipairs(G.consumeables.cards) do
            if consumeable.edition and consumeable.edition.negative then negatives = negatives + 1 end
        end
        Balatest.assert_eq(negatives, 1, "Space Trucking did not make exactly one held consumeable negative")
    end
}
-- No test for increased booster pack contents; the options presented are random

--#endregion
--#region Fun Fun Fun

Balatest.TestPlay {
    name = 'fun_fun_fun_discards_held_card_and_gives_it_permanent_mult',
    category = { 'jokers', 'jojolion', 'fun_fun_fun' },
    jokers = { 'j_jojoker_fun_fun_fun' },
    deck = { cards = {
        { r = '4', s = 'S' },
        { r = '4', s = 'H' },
        { r = '4', s = 'C' } } },
    hand_size = 3,
    discards = 3,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.discard.cards, 2, "Fun Fun Fun did not discard a held card")
        Balatest.assert_eq(#G.hand.cards, 1, "Fun Fun Fun did not remove the discarded card from hand")
        for _, discarded in ipairs(G.discard.cards) do
            if discarded.base.suit == 'Spades' then
                Balatest.assert_eq(discarded.ability.perma_mult or 0, 0, "Fun Fun Fun gave permanent mult to a played card")
            else
                Balatest.assert_eq(discarded.ability.perma_mult, G.jokers.cards[1].ability.extra.mult_mod, "Fun Fun Fun did not give the discarded card permanent mult")
            end
        end
        Balatest.assert_eq(G.GAME.current_round.discards_left, 3, "Fun Fun Fun used up one of the player's discards")
    end
}

Balatest.TestPlay {
    name = 'fun_fun_fun_triggers_on_each_played_hand',
    category = { 'jokers', 'jojolion', 'fun_fun_fun' },
    jokers = { 'j_jojoker_fun_fun_fun' },
    deck = { cards = {
        -- All cards are the same so the random pick does not matter
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } },
    hand_size = 5,
    execute = function()
        Balatest.play_hand { '4S' }
        Balatest.play_hand { '4S' }
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local total_perma_mult = 0
        for _, deck_card in ipairs(G.deck.cards) do
            total_perma_mult = total_perma_mult + (deck_card.ability.perma_mult or 0)
        end
        Balatest.assert_eq(total_perma_mult, G.jokers.cards[1].ability.extra.mult_mod * 2, "Fun Fun Fun did not trigger on each played hand")
    end
}

Balatest.TestPlay {
    name = 'fun_fun_fun_discarded_card_scores_its_permanent_mult',
    category = { 'jokers', 'jojolion', 'fun_fun_fun' },
    jokers = { 'j_jojoker_fun_fun_fun' },
    deck = { cards = {
        { r = '4', s = 'S' },
        { r = '4', s = 'H' },
        { r = '4', s = 'C' },
        { r = '4', s = 'D' } } },
    hand_size = 4,
    execute = function()
        Balatest.play_hand { '4S' }
        Balatest.next_round()
        -- Play every card so the randomly boosted one scores, leaving none held for Fun Fun Fun
        Balatest.play_hand { '4S', '4H', '4C', '4D' }
    end,
    assert = function()
        -- (60 from four of a kind + 4 * 4) * (7 from four of a kind + 3 permanent mult)
        Balatest.assert_chips((60 + 4 * 4) * (7 + 3), "Fun Fun Fun's discarded card did not score its permanent mult")
    end
}

--#endregion
--#region Blue Hawaii

Balatest.TestPlay {
    name = 'blue_hawaii_transfers_enhancement_to_unenhanced_scored_cards',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C' },
        { r = '2', s = 'H' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        Balatest.assert(find_playing_card('2', 'Clubs').config.center == G.P_CENTERS.m_bonus, "Blue Hawaii did not copy the enhancement to the 2 of Clubs")
        Balatest.assert(find_playing_card('2', 'Hearts').config.center == G.P_CENTERS.m_bonus, "Blue Hawaii did not copy the enhancement to the 2 of Hearts")
        Balatest.assert(find_playing_card('2', 'Spades').config.center == G.P_CENTERS.c_base, "Blue Hawaii did not remove the enhancement from the source card")
    end
}

Balatest.TestPlay {
    name = 'blue_hawaii_copies_to_at_most_max_targets_cards',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C' },
        { r = '2', s = 'H' },
        { r = '2', s = 'D' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H', '2D' }
    end,
    assert = function()
        Balatest.assert_eq(count_enhanced_playing_cards('m_bonus'), G.jokers.cards[1].ability.extra.max_targets, "Blue Hawaii copied the enhancement to the wrong number of cards")
        Balatest.assert(find_playing_card('2', 'Spades').config.center == G.P_CENTERS.c_base, "Blue Hawaii did not remove the enhancement from the source card")
    end
}

Balatest.TestPlay {
    name = 'blue_hawaii_only_transfers_from_the_first_enhanced_card',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C', e = 'm_mult' },
        { r = '2', s = 'H' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        Balatest.assert_eq(count_enhanced_playing_cards('c_base'), 2, "Blue Hawaii should leave only the source and the unplayed card unenhanced")
        Balatest.assert(find_playing_card('2', 'Hearts').config.center ~= G.P_CENTERS.c_base, "Blue Hawaii did not enhance the unenhanced scored card")
    end
}

Balatest.TestPlay {
    name = 'blue_hawaii_does_not_enhance_unscored_cards',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C' },
        { r = '5', s = 'H' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '5H' }
    end,
    assert = function()
        Balatest.assert(find_playing_card('2', 'Clubs').config.center == G.P_CENTERS.m_bonus, "Blue Hawaii did not copy the enhancement to the scored 2 of Clubs")
        Balatest.assert(find_playing_card('5', 'Hearts').config.center == G.P_CENTERS.c_base, "Blue Hawaii enhanced an unscored card")
    end
}

Balatest.TestPlay {
    name = 'blue_hawaii_keeps_enhancement_without_unenhanced_targets',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C', e = 'm_mult' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_eq(count_enhanced_playing_cards('c_base'), 1, "Blue Hawaii stripped an enhancement with nothing to copy it to")
    end
}

Balatest.TestPlay {
    name = 'blue_hawaii_copied_enhancements_score_this_hand',
    category = { 'jokers', 'jojolion', 'blue_hawaii' },
    jokers = { 'j_jojoker_blue_hawaii' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'C' },
        { r = '2', s = 'H' },
        { r = '9', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        -- (30 from three of a kind + 3 * 2 + 2 copied Bonus * 30) * 3 from three of a kind
        Balatest.assert_chips((30 + 3 * 2 + 2 * 30) * 3, "Blue Hawaii's copied enhancements did not score")
    end
}

--#endregion
--#region Speed King

Balatest.TestPlay {
    name = 'speed_king_retriggers_the_joker_to_its_right',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_danny' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        -- (5 from high card + 2) * (1 + 15 from Danny + 15 from the retrigger)
        Balatest.assert_chips((5 + 2) * (1 + 15 + 15), "Speed King did not retrigger the joker to its right")
    end
}

Balatest.TestPlay {
    name = 'speed_king_does_not_retrigger_the_joker_to_its_left',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_danny', 'j_jojoker_speed_king' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips((5 + 2) * (1 + 15), "Speed King retriggered the joker to its left")
    end
}

Balatest.TestPlay {
    name = 'speed_king_heats_the_joker_each_round',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking' },
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.heat, 1, "Speed King did not heat the joker at the end of the round")
        Balatest.assert_eq(#G.jokers.cards, 2, "Speed King burnt out the joker too early")
    end
}

Balatest.TestPlay {
    name = 'speed_king_burns_out_the_joker_and_heats_the_next_one',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking', 'j_jojoker_paper_moon_king' },
    execute = function()
        for _ = 1, G.P_CENTERS.j_jojoker_speed_king.config.extra.burnout_rounds do
            Balatest.next_round()
        end
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 2, "Speed King did not burn out the heated joker")
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_paper_moon_king', "Speed King burnt out the wrong joker")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, G.jokers.cards[2].sort_id, "Speed King did not start heating the next joker")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.heat, 0, "Speed King did not reset its heat after a burnout")
        Balatest.assert(not G.jokers.cards[1].debuff, "Speed King stayed debuffed after the next blind started")
    end
}

Balatest.TestPlay {
    name = 'speed_king_heated_joker_snaps_back_when_dragged',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking', 'j_jojoker_paper_moon_king' },
    execute = function()
        Balatest.q(function()
            drag_joker(G.jokers.cards[2], G.jokers.cards[3].T.x + 1)
        end)
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_space_trucking', "The heated joker left Speed King's right side")
    end
}

Balatest.TestPlay {
    name = 'speed_king_pulls_the_heated_joker_along_when_moved',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_paper_moon_king', 'j_jojoker_speed_king', 'j_jojoker_space_trucking' },
    execute = function()
        Balatest.q(function()
            drag_joker(G.jokers.cards[2], G.jokers.cards[1].T.x - 1)
        end)
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].config.center.key, 'j_jojoker_speed_king', "Speed King did not move")
        Balatest.assert_eq(G.jokers.cards[2].config.center.key, 'j_jojoker_space_trucking', "The heated joker did not follow Speed King")
    end
}

Balatest.TestPlay {
    name = 'speed_king_locks_the_next_joker_on_blind_start_after_a_sale',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking', 'j_jojoker_paper_moon_king' },
    execute = function()
        Balatest.next_round()
        Balatest.sell(function() return G.jokers.cards[2] end)
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, G.jokers.cards[2].sort_id, "Speed King did not lock onto the next joker on blind start")
        Balatest.assert(not G.jokers.cards[1].debuff, "Speed King stayed debuffed after the next blind started")
    end
}

Balatest.TestPlay {
    name = 'speed_king_waits_for_blind_start_after_the_heated_joker_is_sold',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking', 'j_jojoker_paper_moon_king' },
    execute = function()
        Balatest.next_round()
        Balatest.sell(function() return G.jokers.cards[2] end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, nil, "Speed King locked onto a new joker before the blind started")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.heat, 0, "Speed King kept the sold joker's heat")
        Balatest.assert(G.jokers.cards[1].debuff, "Speed King was not debuffed after its locked joker was sold")
    end
}

Balatest.TestPlay {
    name = 'speed_king_is_debuffed_after_burning_out_its_joker',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking', 'j_jojoker_paper_moon_king' },
    execute = function()
        for _ = 1, G.P_CENTERS.j_jojoker_speed_king.config.extra.burnout_rounds - 1 do
            Balatest.next_round()
        end
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].debuff, "Speed King was not debuffed after burning out its joker")
    end
}

Balatest.TestPlay {
    name = 'speed_king_does_not_retrigger_while_debuffed',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_danny' },
    execute = function()
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'speed_king_test')
        end)
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips((5 + 2) * (1 + 15), "Speed King retriggered while debuffed")
    end
}

Balatest.TestPlay {
    name = 'speed_king_does_not_heat_while_debuffed',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', 'j_jojoker_space_trucking' },
    execute = function()
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'speed_king_test')
        end)
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.heat, 0, "Speed King heated its joker while debuffed")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, G.jokers.cards[2].sort_id, "Speed King lost its lock while debuffed")
    end
}

Balatest.TestPlay {
    name = 'speed_king_is_disabled_by_an_eternal_joker',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', { id = 'j_jojoker_space_trucking', eternal = true } },
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].debuff, "Speed King was not disabled by the Eternal joker")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, nil, "Speed King heated an Eternal joker")
        Balatest.assert_eq(#G.jokers.cards, 2, "Speed King destroyed an Eternal joker")
    end
}

Balatest.TestPlay {
    name = 'speed_king_recovers_when_the_eternal_joker_is_gone',
    category = { 'jokers', 'jojolion', 'speed_king' },
    jokers = { 'j_jojoker_speed_king', { id = 'j_jojoker_space_trucking', eternal = true } },
    execute = function()
        Balatest.wait()
        Balatest.q(function()
            G.jokers.cards[2].ability.eternal = nil
        end)
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].debuff, "Speed King stayed disabled after the Eternal joker lost Eternal")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.target_id, G.jokers.cards[2].sort_id, "Speed King did not heat the joker once it was no longer Eternal")
    end
}

--#endregion
