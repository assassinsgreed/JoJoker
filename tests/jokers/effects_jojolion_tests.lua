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