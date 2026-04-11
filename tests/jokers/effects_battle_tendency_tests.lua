--#region German Engineering
Balatest.TestPlay {
    name = 'german_engineering_levels_up_high_card_when_single_nine_played',
    category = { 'jokers', 'battle_tendency', 'german_engineering' },
    jokers = { 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        local high_card_hand_level = G.GAME.hands["High Card"].level
        Balatest.assert_eq(high_card_hand_level, 2, "High Card hand wasn't levelled up to level 2")
    end
}
Balatest.TestPlay {
    name = 'german_engineering_does_not_level_up_high_card_when_not_single_nine_played',
    category = { 'jokers', 'battle_tendency', 'german_engineering' },
    jokers = { 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S', '9D' }
    end,
    assert = function()
        local high_card_hand_level = G.GAME.hands["High Card"].level
        Balatest.assert_eq(high_card_hand_level, 1, "High Card hand was levelled up when it shouldn't have")
    end
}
Balatest.TestPlay {
    name = 'german_engineering_duplicates_played_single_9',
    category = { 'jokers', 'battle_tendency', 'german_engineering' },
    jokers = { 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S' }
        Balatest.next_round() -- Reload hand to see duplicated card
    end,
    assert = function()
        local nine_of_spades_count = 0
        for k,v in pairs(G.hand.cards) do
            if v:get_id() == 9 and v:is_suit("Spades") then
                nine_of_spades_count = nine_of_spades_count + 1
            end
        end

        Balatest.assert_eq(nine_of_spades_count, 2, "German Engineering did not duplicate single 9 played")
    end
}
Balatest.TestPlay {
    name = 'german_engineering_does_not_duplicate_cards_when_not_single_nine_played',
    category = { 'jokers', 'battle_tendency', 'german_engineering' },
    jokers = { 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S', '9D' }
        Balatest.next_round() -- Reload hand to see duplicated card
    end,
    assert = function()
        local nine_count = 0
        for k,v in pairs(G.hand.cards) do
            if v:get_id() == 9 then
                nine_count = nine_count + 1
            end
        end

        Balatest.assert_eq(nine_count, 4, "German Engineering duplicated 9 card after multiple played")
    end
}
--#endregion

--#region Clacker Balls
Balatest.TestPlay {
    name = 'clacker_balls_do_not_retrigger_when_scored_hand_greater_than_3',
    category = { 'jokers', 'battle_tendency', 'clacker_balls' },
    jokers = { 'j_jojoker_clacker_balls' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2D', '3S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(208, "Clacker Balls retriggered when scored hand is greater than 3")
    end
}
Balatest.TestPlay {
    name = 'clacker_balls_retrigger_when_scored_hand_equal_to_3',
    category = { 'jokers', 'battle_tendency', 'clacker_balls' },
    jokers = { 'j_jojoker_clacker_balls' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2D' }
    end,
    assert = function()
        Balatest.assert_chips(126, "Clacker Balls retriggered when scored hand is equal to 3")
    end
}
Balatest.TestPlay {
    name = 'clacker_balls_do_not_retrigger_when_scored_hand_less_than_3',
    category = { 'jokers', 'battle_tendency', 'clacker_balls' },
    jokers = { 'j_jojoker_clacker_balls' },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(36, "Clacker Balls retriggered when scored hand is less than 3")
    end
}
--#endregion