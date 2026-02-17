--#region Magician's Red
Balatest.TestPlay {
    name = 'magician_red_gives_no_money_when_score_does_not_catch_fire',
    category = { 'jokers', 'stardust_crusaders', 'magician_red' },
    jokers = { 'j_jojoker_magician_red' },
    execute = function()
        Balatest.play_hand { '4S', '4C', '4H', '5H', '5C' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Magician's Red incorrectly gave money when score did not catch fire")
    end
}
Balatest.TestPlay {
    name = 'magician_red_gives_correct_money_when_score_catches_fire',
    category = { 'jokers', 'stardust_crusaders', 'magician_red' },
    jokers = { 'j_jojoker_magician_red' },
    execute = function()
        Balatest.play_hand { '4S', '5S', '6S', '7S', '8S' }
    end,
    assert = function()
        Balatest.assert_dollars(5, "Magician's Red did not give expected money when score caught fire")
    end
}
--#endregion
--#region Yellow Temperance
Balatest.TestPlay {
    name = 'yellow_temperance_retriggers_scored_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { 'KS', 'KC' }
    end,
    assert = function()
        Balatest.assert_chips(100, "Yellow Temperance did not retrigger scored face cards")
    end
}
Balatest.TestPlay {
    name = 'yellow_temperance_does_not_retrigger_unscored_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { 'AS', 'KC' }
    end,
    assert = function()
        Balatest.assert_chips(16, "Yellow Temperance retrigger unscored face cards")
    end
}
Balatest.TestPlay {
    name = 'yellow_temperance_does_not_retrigger_non_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Yellow Temperance retriggered scored non-face cards")
    end
}
--#endregion
--#region Star Platinum
Balatest.TestPlay {
    name = 'star_platinum_gives_one_extra_hand_when_triggered',
    category = { 'jokers', 'stardust_crusaders', 'star_platinum' },
    jokers = { 'j_jojoker_star_platinum' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 3, "Star Platinum did not give a hand when triggering")
    end
}
--#endregion
--#region Wheel of Fortune
Balatest.TestPlay {
    name = 'wheel_of_fortune_guarantees_tarot_effect',
    category = { 'jokers', 'stardust_crusaders', 'wheel_of_fortune' },
    jokers = { 'j_jojoker_wheel_of_fortune' },
    consumeables = { 'c_wheel_of_fortune' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        local has_edition = G.jokers.cards[1].edition.key ~= nil -- Could be multiple effects
        Balatest.assert(has_edition, "Wheel of Fortune did not guarantee tarot effect")
    end
}
--#endregion