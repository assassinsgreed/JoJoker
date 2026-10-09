--#region Smooth Operator
-- (The pre-scoring shuffle cannot be tested with Balatest, but a single-card
-- hand skips the shuffle entirely, letting us test the chip payout)
Balatest.TestPlay {
    name = 'smooth_operator_gives_chips_for_each_scored_card',
    category = { 'jokers', 'the_jojolands', 'smooth_operator' },
    jokers = { 'j_jojoker_smooth_operator' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        -- High card 2: (5 base + 2 rank + 20 from Smooth Operators) * 1 mult
        Balatest.assert_chips(27, "Smooth Operators did not add chips for scored cards")
    end
}
--#endregion

--#region John Rod
local function count_cards(rank, suit)
    local count = 0
    for _, c in ipairs(G.playing_cards) do
        if c.base.value == rank and (not suit or c.base.suit == suit) then
            count = count + 1
        end
    end
    return count
end

Balatest.TestPlay {
    name = 'john_rod_destroys_highest_ranked_scored_card_and_gains_xmult',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    execute = function()
        Balatest.play_hand { 'KS', 'KH', '4S', '4H' }
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 51, "John Rod did not destroy exactly one card")
        Balatest.assert_eq(count_cards('King'), 3, "John Rod did not destroy the highest ranked scored card")
        Balatest.assert_eq(count_cards('4'), 4, "John Rod destroyed a lower ranked card")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + G.jokers.cards[1].ability.extra.Xmult_mod, "John Rod did not gain Xmult after destroying a card")
    end
}
Balatest.TestPlay {
    name = 'john_rod_ignores_unscored_cards',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    execute = function()
        Balatest.play_hand { 'KS', '3H', '3C' }
    end,
    assert = function()
        Balatest.assert_eq(count_cards('King', 'Spades'), 1, "John Rod destroyed an unscored card")
        Balatest.assert_eq(count_cards('3'), 3, "John Rod did not destroy the highest ranked scored card")
    end
}
Balatest.TestPlay {
    name = 'john_rod_gains_more_xmult_for_glass_cards',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    deck = { cards = {
        { r = 'A', s = 'S', e = 'm_glass' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 8, "John Rod did not destroy the glass card")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + G.jokers.cards[1].ability.extra.glass_Xmult_mod, "John Rod did not gain the glass Xmult")
    end
}
Balatest.TestPlay {
    name = 'john_rod_gains_xmult_for_each_hand_played',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 50, "John Rod did not destroy a card for each hand")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1 + 2 * G.jokers.cards[1].ability.extra.Xmult_mod, "John Rod did not gain Xmult for each hand")
    end
}
Balatest.TestPlay {
    name = 'john_rod_does_not_destroy_rankless_cards',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' },
        { r = '3', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 9, "John Rod destroyed a stone card")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "John Rod gained Xmult without destroying a card")
    end
}
Balatest.TestPlay {
    name = 'john_rod_gives_its_current_xmult',
    category = { 'jokers', 'the_jojolands', 'john_rod' },
    jokers = { 'j_jojoker_john_rod' },
    execute = function()
        G.jokers.cards[1].ability.extra.Xmult = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        -- High card 2: (5 base + 2 rank) * 1 mult * X2
        Balatest.assert_chips(14, "John Rod did not apply its Xmult")
    end
}
--#endregion
