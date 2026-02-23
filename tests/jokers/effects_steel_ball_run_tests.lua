--#region The Fifth Lesson
Balatest.TestPlay {
    name = 'the_fifth_lesson_shortcut_applies',
    category = { 'jokers', 'steel_ball_run', 'the_fifth_lesson' },
    jokers = { 'j_jojoker_the_fifth_lesson' },
    execute = function()
        Balatest.play_hand { 'AS', 'KC', 'QD', '10H', '9S' } -- Straight with missing Jack
    end,
    assert = function()
        Balatest.assert_chips(320, "The Fifth Lesson didn't play a straight")
    end
}
--#endregion
--#region Turbo Eyes
Balatest.TestPlay {
    name = 'turbo_eyes_adds_top_two_cards_chips_to_score',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
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
        -- 5 from base score + 4 from 4 high card + 2 4s
        Balatest.assert_chips(9 + 4 * 2, "Turbo Eyes did not give correct chips based on top 2 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_adds_fewer_than_two_cards_chips_to_score_when_deck_has_fewer_than_two_cards',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card + 1 4s
        Balatest.assert_chips(9 + 4 * 1, "Turbo Eyes did not give correct chips based on up to top 2 cards of deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_adds_no_additional_chips_when_deck_is_empty',
    category = { 'jokers', 'steel_ball_run', 'turbo_eyes' },
    jokers = { 'j_jojoker_turbo_eyes' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In hand
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card
        Balatest.assert_chips(9 + 4 * 0, "Turbo Eyes did not give correct chips based on 0 cards remaining in deck")
    end
}

Balatest.TestPlay {
    name = 'turbo_eyes_and_epitaph__adds_top_six_cards_chips_to_score',
    category = { 'jokers', 'steel_ball_run', 'golden_wind', 'turbo_eyes', 'epitaph' },
    jokers = { 'j_jojoker_turbo_eyes', 'j_jojoker_epitaph' },
    deck = { cards = {
        -- All cards are the same so we don't have to account for different hands being delt
        { r = '4', s = 'S' },
        { r = '4', s = 'S' }, -- In hand
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' },
        { r = '4', s = 'S' } } }, -- In deck
    hand_size = 2,
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        -- 5 from base score + 4 from 4 high card + 6 4s, *2 because it is triggered for each joker
        Balatest.assert_chips(9 + 4 * 6 * 2, "Turbo Eyes and Epitaph combined did not give correct chips based on top 6 cards of deck")
    end
}
--#endregion