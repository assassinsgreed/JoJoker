-- #region Joestar Birthmark
Balatest.TestPlay {
    name = 'joestar_birthmark_increases_chips_and_mult_of_scored_cards',
    category = { 'jokers', 'stardust_crusaders', 'joestar_birthmark' },
    jokers = { 'j_jojoker_joestar_birthmark' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'H' },
        { r = '5', s = 'H' },
        { r = '5', s = 'C' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH', 'QH' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstFacePermaChips = G.deck.cards[1].ability.perma_bonus
        local secondFacePermaChips = G.deck.cards[2].ability.perma_bonus
        local firstFacePermaMult = G.deck.cards[1].ability.perma_mult
        local secondFacePermaMult = G.deck.cards[2].ability.perma_mult
        Balatest.assert_eq(firstFacePermaChips, G.jokers.cards[1].ability.extra.chips, "Joestar Birthmark did not permanently increase chips of first scored card.")
        Balatest.assert_eq(secondFacePermaChips, G.jokers.cards[1].ability.extra.chips, "Joestar Birthmark did not permanently increase chips of second scored card.")
        Balatest.assert_eq(firstFacePermaMult, G.jokers.cards[1].ability.extra.mult, "Joestar Birthmark did not permanently increase mult of first scored card.")
        Balatest.assert_eq(secondFacePermaMult, G.jokers.cards[1].ability.extra.mult, "Joestar Birthmark did not permanently increase mult of second scored card.")
    end
}

Balatest.TestPlay {
    name = 'joestar_birthmark_further_increases_chips_bonus_of_already_increased_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'joestar_birthmark' },
    jokers = { 'j_jojoker_joestar_birthmark' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'H' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH' } -- Play all and check the deck afterward
        Balatest.next_round()
        Balatest.play_hand { 'QH' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstFaceCardPermaChips = G.deck.cards[1].ability.perma_bonus
        local firstFaceCardPermaMult = G.deck.cards[1].ability.perma_mult
        Balatest.assert_eq(firstFaceCardPermaChips, G.jokers.cards[1].ability.extra.chips * 2, "Joestar Birthmark did not permanently increase chips of first scored card.")
        Balatest.assert_eq(firstFaceCardPermaMult, G.jokers.cards[1].ability.extra.mult * 2, "Joestar Birthmark did not permanently increase mult of first scored card.")
    end
}
-- #endregion