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

--#region Johngalli A
Balatest.TestPlay {
    name = 'johngalli_a_deals_shop_jokers_face_down',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    execute = function()
        only_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(#G.shop_jokers.cards > 0, "The shop had no jokers to check")
        Balatest.assert_eq(count_face_down_cards(G.shop_jokers), #G.shop_jokers.cards, "Johngalli A left a shop joker face up")
    end
}

Balatest.TestPlay {
    name = 'johngalli_a_deals_rerolled_shop_jokers_face_down',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    execute = function()
        only_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
        reroll_shop_for_free()
    end,
    assert = function()
        Balatest.assert(#G.shop_jokers.cards > 0, "The rerolled shop had no jokers to check")
        Balatest.assert_eq(count_face_down_cards(G.shop_jokers), #G.shop_jokers.cards, "Johngalli A left a rerolled shop joker face up")
    end
}

Balatest.TestPlay {
    name = 'johngalli_a_leaves_shop_consumables_face_up',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    execute = function()
        no_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(#G.shop_jokers.cards > 0, "The shop had no consumables to check")
        Balatest.assert_eq(count_face_down_cards(G.shop_jokers), 0, "Johngalli A turned a shop consumable face down")
    end
}

local johngalli_bought

Balatest.TestPlay {
    name = 'johngalli_a_bought_joker_is_revealed_with_an_edition',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    dollars = 100,
    execute = function()
        only_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() G.shop_jokers.cards[1]:set_edition(nil, true, true) end)
        Balatest.buy(function()
            johngalli_bought = G.shop_jokers.cards[1]
            return johngalli_bought
        end)
    end,
    assert = function()
        Balatest.assert_eq(johngalli_bought.area, G.jokers, "The face-down joker was not bought")
        Balatest.assert_eq(johngalli_bought.facing, 'front', "The bought joker stayed face down")
        Balatest.assert(johngalli_bought.edition ~= nil, "Johngalli A did not give the bought joker an edition")
        Balatest.assert(not johngalli_bought.edition.negative, "Johngalli A gave the bought joker Negative")
    end
}

Balatest.TestPlay {
    name = 'johngalli_a_keeps_the_existing_edition_of_a_bought_joker',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    dollars = 100,
    execute = function()
        only_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() G.shop_jokers.cards[1]:set_edition('e_foil', true, true) end)
        Balatest.buy(function()
            johngalli_bought = G.shop_jokers.cards[1]
            return johngalli_bought
        end)
    end,
    assert = function()
        Balatest.assert(johngalli_bought.edition and johngalli_bought.edition.foil, "Johngalli A replaced the bought joker's existing edition")
    end
}

Balatest.TestPlay {
    name = 'johngalli_a_sold_still_reveals_face_down_jokers_without_an_edition',
    category = { 'jokers', 'stone_ocean', 'johngalli_a' },
    jokers = { 'j_jojoker_johngalli_a' },
    dollars = 100,
    execute = function()
        only_jokers_in_shop()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() G.shop_jokers.cards[1]:set_edition(nil, true, true) end)
        Balatest.sell(function() return G.jokers.cards[1] end)
        Balatest.buy(function()
            johngalli_bought = G.shop_jokers.cards[1]
            return johngalli_bought
        end)
    end,
    assert = function()
        Balatest.assert_eq(johngalli_bought.facing, 'front', "A joker bought face down after selling Johngalli A stayed face down")
        Balatest.assert(johngalli_bought.edition == nil, "A joker bought after selling Johngalli A still gained an edition")
    end
}
--#endregion
