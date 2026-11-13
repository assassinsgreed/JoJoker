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

--#region Anasui (Male)

Balatest.TestPlay {
    name = 'anasui_m_adds_hands_and_removes_a_discard_when_added',
    category = { 'jokers', 'stone_ocean', 'anasui_m' },
    jokers = { 'j_jojoker_anasui_m' },
    hands = 1,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.GAME.current_round.hands_left, 1 + extra.hands, "Anasui (Male) did not add hands")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 3 + extra.discards, "Anasui (Male) did not remove a discard")
        Balatest.assert_eq(G.GAME.round_resets.hands, 1 + extra.hands, "Anasui (Male) did not change round reset hands")
        Balatest.assert_eq(G.GAME.round_resets.discards, 3 + extra.discards, "Anasui (Male) did not change round reset discards")
    end
}

Balatest.TestPlay {
    name = 'anasui_m_reverts_hands_and_discards_when_sold',
    category = { 'jokers', 'stone_ocean', 'anasui_m' },
    jokers = { 'j_jojoker_anasui_m' },
    hands = 1,
    discards = 3,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 1, "Anasui (Male) did not remove its hands when sold")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 3, "Anasui (Male) did not return its discard when sold")
    end
}

Balatest.TestPlay {
    name = 'anasui_m_does_not_shift_totals_after_debuff_cycle',
    category = { 'jokers', 'stone_ocean', 'anasui_m' },
    jokers = { 'j_jojoker_anasui_m' },
    hands = 1,
    discards = 3,
    execute = function()
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'balatest')
            return true
        end)
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], false, 'balatest')
            return true
        end)
        Balatest.wait()
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.GAME.round_resets.hands, 1 + extra.hands, "Anasui (Male) shifted round reset hands after a debuff cycle")
        Balatest.assert_eq(G.GAME.round_resets.discards, 3 + extra.discards, "Anasui (Male) shifted round reset discards after a debuff cycle")
    end
}

Balatest.TestPlay {
    name = 'anasui_m_bonus_persists_into_the_next_round',
    category = { 'jokers', 'stone_ocean', 'anasui_m' },
    jokers = { 'j_jojoker_anasui_m' },
    hands = 1,
    discards = 3,
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.GAME.current_round.hands_left, 1 + extra.hands, "Anasui (Male) hands did not carry into the next round")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 3 + extra.discards, "Anasui (Male) discards did not carry into the next round")
    end
}

--#endregion

--#region Anasui (Female)

Balatest.TestPlay {
    name = 'anasui_f_adds_discards_and_removes_a_hand_when_added',
    category = { 'jokers', 'stone_ocean', 'anasui_f' },
    jokers = { 'j_jojoker_anasui_f' },
    hands = 3,
    discards = 1,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.GAME.current_round.hands_left, 3 + extra.hands, "Anasui (Female) did not remove a hand")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 1 + extra.discards, "Anasui (Female) did not add discards")
        Balatest.assert_eq(G.GAME.round_resets.hands, 3 + extra.hands, "Anasui (Female) did not change round reset hands")
        Balatest.assert_eq(G.GAME.round_resets.discards, 1 + extra.discards, "Anasui (Female) did not change round reset discards")
    end
}

Balatest.TestPlay {
    name = 'anasui_f_reverts_hands_and_discards_when_sold',
    category = { 'jokers', 'stone_ocean', 'anasui_f' },
    jokers = { 'j_jojoker_anasui_f' },
    hands = 3,
    discards = 1,
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 3, "Anasui (Female) did not return its hand when sold")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 1, "Anasui (Female) did not remove its discards when sold")
    end
}

Balatest.TestPlay {
    name = 'anasui_f_does_not_shift_totals_after_debuff_cycle',
    category = { 'jokers', 'stone_ocean', 'anasui_f' },
    jokers = { 'j_jojoker_anasui_f' },
    hands = 3,
    discards = 1,
    execute = function()
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], true, 'balatest')
            return true
        end)
        Balatest.q(function()
            SMODS.debuff_card(G.jokers.cards[1], false, 'balatest')
            return true
        end)
        Balatest.wait()
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(G.GAME.round_resets.hands, 3 + extra.hands, "Anasui (Female) shifted round reset hands after a debuff cycle")
        Balatest.assert_eq(G.GAME.round_resets.discards, 1 + extra.discards, "Anasui (Female) shifted round reset discards after a debuff cycle")
    end
}

Balatest.TestPlay {
    name = 'anasui_m_and_anasui_f_together_net_one_hand_and_one_discard',
    category = { 'jokers', 'stone_ocean', 'anasui_f', 'anasui_m' },
    jokers = { 'j_jojoker_anasui_m', 'j_jojoker_anasui_f' },
    hands = 3,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 4, "Both Anasuis together did not net +1 hand")
        Balatest.assert_eq(G.GAME.current_round.discards_left, 4, "Both Anasuis together did not net +1 discard")
    end
}

--#endregion
