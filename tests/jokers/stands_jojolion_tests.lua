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
        { r = '2', s = 'H', e = 'm_glass' } } },
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