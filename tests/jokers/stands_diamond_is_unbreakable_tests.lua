--#region Red Hot Chili Pepper
Balatest.TestPlay {
    name = 'red_hot_chili_pepper_gives_zero_mult_when_no_money',
    category = { 'jokers', 'diamond_is_unbreakable', 'red_hot_chili_pepper' },
    jokers = { 'j_jojoker_red_hot_chili_pepper' },
    dollars = 0,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Red Hot Chili Pepper gave mult when no money held")
    end
}
Balatest.TestPlay {
    name = 'red_hot_chili_pepper_gives_mult_based_on_money',
    category = { 'jokers', 'diamond_is_unbreakable', 'red_hot_chili_pepper' },
    jokers = { 'j_jojoker_red_hot_chili_pepper' },
    dollars = 10,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local expected_chips = 7 * (G.jokers.cards[1].ability.extra.mult_mod * G.GAME.dollars + 1) -- Base 7 chips + (dollars * # mult per dollar + 1 from pair)
        Balatest.assert_chips(expected_chips, "Red Hot Chili Pepper didn't give mult based on money")
    end
}
--#endregion