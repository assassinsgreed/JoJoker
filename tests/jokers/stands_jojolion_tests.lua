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