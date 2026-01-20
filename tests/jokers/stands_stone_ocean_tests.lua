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

-- #region Stone Free
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
-- #endregion