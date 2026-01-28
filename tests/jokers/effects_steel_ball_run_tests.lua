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