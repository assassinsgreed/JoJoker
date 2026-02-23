--#region Epitaph
Balatest.TestPlay {
    name = 'epitaph_adds_top_four_cards_chips_to_score',
    category = { 'jokers', 'golden_wind', 'epitaph' },
    jokers = { 'j_jojoker_epitaph' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from Queen high card + 4 4s
        Balatest.assert_chips(9 + 4 * 4, "Epitaph did not give correct chips based on top 4 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'epitaph_adds_fewer_than_four_cards_chips_to_score_when_deck_has_fewer_than_four_cards',
    category = { 'jokers', 'golden_wind', 'epitaph' },
    jokers = { 'j_jojoker_epitaph' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from Queen high card + 2 4s
        Balatest.assert_chips(9 + 4 * 2, "Epitaph did not give correct chips based on up to top 4 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'epitaph_adds_no_additional_chips_when_deck_is_empty',
    category = { 'jokers', 'golden_wind', 'epitaph' },
    jokers = { 'j_jojoker_epitaph' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In hand
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from Queen high card
        Balatest.assert_chips(9 + 4 * 0, "Epitaph did not give correct chips based on 0 cards remaining in deck")
    end
}
--#endregion