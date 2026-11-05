--#region Higashikata House

Balatest.TestPlay {
    name = 'higashikata_house_does_not_give_chips_for_non_full_house',
    category = { 'jokers', 'jojolion', 'higashikata_house' },
    jokers = { 'j_jojoker_higashikata_house' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Higashikata House incorrectly gave chips for non-Full House")
    end
}

Balatest.TestPlay {
    name = 'higashikata_house_gives_chips_for_full_house',
    category = { 'jokers', 'jojolion', 'higashikata_house' },
    jokers = { 'j_jojoker_higashikata_house' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C', '3D', '3C' }
    end,
    assert = function()

        Balatest.assert_chips(528, "Higashikata House incorrectly gave chips for non-Full House")
    end
}

--#endregion
--#region Higashikata Fruit Parlor

Balatest.TestPlay {
    name = 'higashikata_fruit_parlor_gives_money_for_pair',
    category = { 'jokers', 'jojolion', 'higashikata_fruit_parlor' },
    jokers = { 'j_jojoker_higashikata_fruit_parlor' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '4C', '5D', '7C' }
    end,
    assert = function()
        Balatest.assert_dollars(2, "Higashikata Fruit Parlor incorrectly gave money for Pair")
    end
}

Balatest.TestPlay {
    name = 'higashikata_fruit_parlor_gives_money_for_two_pair',
    category = { 'jokers', 'jojolion', 'higashikata_fruit_parlor' },
    jokers = { 'j_jojoker_higashikata_fruit_parlor' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '4C', '4D', '7C' }
    end,
    assert = function()
        Balatest.assert_dollars(4, "Higashikata Fruit Parlor incorrectly gave money for Two Pair")
    end
}
--#endregion

--#region Wall Eyes
Balatest.TestPlay {
    name = 'wall_eyes_gives_no_chips_without_stone_cards',
    category = { 'jokers', 'jojolion', 'wall_eyes' },
    jokers = { 'j_jojoker_wall_eyes' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Wall Eyes gave chips with no stone cards in the deck")
    end
}

Balatest.TestPlay {
    name = 'wall_eyes_gives_chips_for_each_stone_card_in_full_deck',
    category = { 'jokers', 'jojolion', 'wall_eyes' },
    jokers = { 'j_jojoker_wall_eyes' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '3', s = 'H', e = 'm_stone' },
        { r = '4', s = 'H', e = 'm_stone' },
        { r = '5', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 2 + 2 * G.jokers.cards[1].ability.extra.chips, "Wall Eyes did not give chips for the 2 stone cards held in hand")
    end
}

Balatest.TestPlay {
    name = 'wall_eyes_counts_stone_cards_added_during_the_run',
    category = { 'jokers', 'jojolion', 'wall_eyes' },
    jokers = { 'j_jojoker_wall_eyes', 'j_jojoker_doctor_wu' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '5', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(5 + 2 + G.jokers.cards[1].ability.extra.chips, "Wall Eyes did not count the stone card Doctor Wu added")
    end
}

Balatest.TestPlay {
    name = 'wall_eyes_gives_money_for_stone_cards_held_at_end_of_round',
    category = { 'jokers', 'jojolion', 'wall_eyes' },
    jokers = { 'j_jojoker_wall_eyes' },
    deck = { cards = {
        { r = '2', s = 'S' },
        { r = '3', s = 'H', e = 'm_stone' },
        { r = '4', s = 'H', e = 'm_stone' },
        { r = '5', s = 'C' } } },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_dollars(2 * G.jokers.cards[1].ability.extra.dollars, "Wall Eyes did not give money for each stone card held in hand")
    end
}

Balatest.TestPlay {
    name = 'wall_eyes_gives_no_money_for_stone_cards_not_held_at_end_of_round',
    category = { 'jokers', 'jojolion', 'wall_eyes' },
    jokers = { 'j_jojoker_wall_eyes' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '5', s = 'C' },
        { r = '6', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_dollars(0, "Wall Eyes gave money for a stone card that was played rather than held")
    end
}
--#endregion