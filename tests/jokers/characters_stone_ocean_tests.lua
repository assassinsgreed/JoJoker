--#region Savage Garden
Balatest.TestPlay {
    name = 'savage_garden_does_not_give_xmult_on_hand_that_is_not_final',
    category = { 'jokers', 'stone_ocean', 'savage_garden' },
    jokers = { 'j_jojoker_savage_garden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Savage Garden gave Xmult on hand that is not final.")
    end
}
-- Balatest cannot test final hand functionality properly
--#endregion
--#region Pucci
Balatest.TestPlay {
    name = 'pucci_retriggers_on_prime_rank',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Pucci did not retrigger on prime rank.")
    end
}
Balatest.TestPlay {
    name = 'pucci_does_not_retrigger_on_non_prime_rank',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9, "Pucci retriggered on non-prime rank.")
    end
}
Balatest.TestPlay {
    name = 'pucci_only_retriggers_scored_cards',
    category = { 'jokers', 'stone_ocean', 'pucci' },
    jokers = { 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '2D', '3S', '3H' }
    end,
    assert = function()
        Balatest.assert_chips(44, "Pucci retriggered on prime ranks that did not score.")
    end
}
--#endregion
--#region Loccobarocco and Charlotte
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_gives_multiplied_chips_of_debuffed_scored_card',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    execute = function()
        Balatest.q(function()
            debuff_playing_cards('9', 'Spades')
            return true
        end)
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        Balatest.assert_chips(50, "Loccobarocco and Charlotte did not multiply the chips of a debuffed scored card.")
    end
}
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_gives_chips_for_each_debuffed_scored_card',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    execute = function()
        Balatest.q(function()
            debuff_playing_cards('9')
            return true
        end)
        Balatest.play_hand { '9S', '9H' }
    end,
    assert = function()
        Balatest.assert_chips(200, "Loccobarocco and Charlotte did not give chips for every debuffed scored card.")
    end
}
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_includes_enhancement_chips',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    deck = { cards = {
        { r = '9', s = 'S', e = 'm_bonus' },
        { r = '2', s = 'H' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.q(function()
            debuff_playing_cards('9', 'Spades')
            return true
        end)
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        Balatest.assert_chips(200, "Loccobarocco and Charlotte did not multiply the enhancement chips of a debuffed card.")
    end
}
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_only_multiplies_debuffed_cards',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    execute = function()
        Balatest.q(function()
            debuff_playing_cards('9', 'Spades')
            return true
        end)
        Balatest.play_hand { '9S', '9H' }
    end,
    assert = function()
        Balatest.assert_chips(128, "Loccobarocco and Charlotte gave chips for a card that was not debuffed.")
    end
}
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_does_not_give_chips_without_debuffed_cards',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    execute = function()
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        Balatest.assert_chips(14, "Loccobarocco and Charlotte gave chips when no card was debuffed.")
    end
}
Balatest.TestPlay {
    name = 'loccobarocco_and_charlotte_ignores_debuffed_unscored_cards',
    category = { 'jokers', 'stone_ocean', 'loccobarocco_and_charlotte' },
    jokers = { 'j_jojoker_loccobarocco_and_charlotte' },
    execute = function()
        Balatest.q(function()
            debuff_playing_cards('2', 'Hearts')
            return true
        end)
        Balatest.play_hand { '9S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(14, "Loccobarocco and Charlotte gave chips for a debuffed card that did not score.")
    end
}
--#endregion
