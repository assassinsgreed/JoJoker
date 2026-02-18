--#region Goo Goo Dolls
Balatest.TestPlay {
    name = 'goo_goo_dolls_does_not_give_mult_for_incorrect_card_ranks',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '10H' }
    end,
    assert = function()
        Balatest.assert_chips(15, "Goo Goo Dolls gave mult for a card rank outside of 2-6")
    end
}
Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_mult_for_cards_within_rank_2_to_6',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '4S', '4C' }
    end,
    assert = function()
        Balatest.assert_chips(18 * (G.jokers.cards[1].ability.extra.mult * 2 + 2), "Goo Goo Dolls did not give mult for each scored low card")
    end
}
Balatest.TestPlay {
    name = 'goo_goo_dolls_gives_mult_only_for_scored_cards',
    category = { 'jokers', 'stone_ocean', 'goo_goo_dolls' },
    jokers = { 'j_jojoker_goo_goo_dolls' },
    execute = function()
        Balatest.play_hand { '4S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(9 * (G.jokers.cards[1].ability.extra.mult + 1), "Goo Goo Dolls did not give mult for only scored low card")
    end
}
--#endregion

--#region Stone Free
Balatest.TestPlay {
    name = 'stone_free_retriggers_each_stone_card_when_played',
    category = { 'jokers', 'stone_ocean', 'stone_free' },
    jokers = { 'j_jojoker_stone_free' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(205, "Stone Free did not retrigger each stone card when played")
    end
}
--#endregion
--#region Made in Heaven
Balatest.TestPlay {
    name = 'made_in_heaven_reduces_hands_and_discards',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, G.jokers.cards[1].ability.extra.hands, "Made in Heaven did not reduce hands")
        Balatest.assert_eq(G.GAME.current_round.discards_left, G.jokers.cards[1].ability.extra.discards, "Made in Heaven did not reduce discards")
    end
}
Balatest.TestPlay {
    name = 'made_in_heaven_sets_xmult_to_total_lost_hands_and_discards',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 6, "Made in Heaven did not gain XMult for each lost hand and discard")
    end
}
Balatest.TestPlay {
    name = 'made_in_heaven_sets_hand_size_to_deck_size',
    category = { 'jokers', 'stone_ocean', 'made_in_heaven' },
    jokers = { 'j_jojoker_made_in_heaven' },
    hands = 4,
    discards = 3,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52, "Made in Heaven did not set hand size to deck size")
    end
}
--#endregion
--#region Dragon's Dream
Balatest.TestPlay {
    name = 'dragons_dream_randomly_gains_or_loses_values_on_hand_played',
    category = { 'jokers', 'stone_ocean', 'dragons_dream' },
    jokers = { 'j_jojoker_dragons_dream' },
    execute = function()
        Original_chips = G.jokers.cards[1].ability.extra.curr_chips
        Original_mult = G.jokers.cards[1].ability.extra.curr_mult
        Original_money = G.jokers.cards[1].ability.extra.curr_money
        Original_xmult = G.jokers.cards[1].ability.extra.curr_Xmult

        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local valuesChanged = Original_chips ~= G.jokers.cards[1].ability.extra.curr_chips or
            Original_mult ~= G.jokers.cards[1].ability.extra.curr_mult or
            Original_money ~= G.jokers.cards[1].ability.extra.curr_money or
            Original_xmult ~= G.jokers.cards[1].ability.extra.curr_Xmult

        Balatest.assert_eq(valuesChanged, true, "Dragon's Dream did not change any values on hand played")
    end
}
--#endregion
--#region Green Baby
Balatest.TestPlay {
    name = 'green_baby_doubles_high_card_chips',
    category = { 'jokers', 'stone_ocean', 'green_baby' },
    jokers = { 'j_jojoker_green_baby' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(18, "Green Baby didn't double chips on scored High Card hand.")
    end
}
Balatest.TestPlay {
    name = 'green_baby_does_not_double_chips_on_non_high_card_hand',
    category = { 'jokers', 'stone_ocean', 'green_baby' },
    jokers = { 'j_jojoker_green_baby' },
    execute = function()
        Balatest.play_hand { '9S', '9D' }
    end,
    assert = function()
        Balatest.assert_chips(56, "Green Baby doubled chips on non-High Card hand.")
    end
}
--#endregion