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
-- #region Hat Hair
local function force_hat_hair_roll(roll)
    local original_pseudorandom = pseudorandom
    pseudorandom = function(seed, ...)
        if seed == 'hat_hair' then return roll end
        return original_pseudorandom(seed, ...)
    end
    return function() pseudorandom = original_pseudorandom end
end

local restore_pseudorandom

Balatest.TestPlay {
    name = 'hat_hair_gives_chips_on_low_roll',
    category = { 'jokers', 'stardust_crusaders', 'hat_hair' },
    jokers = { 'j_jojoker_hat_hair' },
    execute = function()
        restore_pseudorandom = force_hat_hair_roll(0.1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        restore_pseudorandom()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.chips, "Hat Hair did not give chips on a low roll")
    end
}

Balatest.TestPlay {
    name = 'hat_hair_gives_mult_on_high_roll',
    category = { 'jokers', 'stardust_crusaders', 'hat_hair' },
    jokers = { 'j_jojoker_hat_hair' },
    execute = function()
        restore_pseudorandom = force_hat_hair_roll(0.9)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        restore_pseudorandom()
        Balatest.assert_chips(7 * (1 + G.jokers.cards[1].ability.extra.mult), "Hat Hair did not give mult on a high roll")
    end
}

Balatest.TestPlay {
    name = 'hat_hair_gives_chips_or_mult_on_every_played_hand',
    category = { 'jokers', 'stardust_crusaders', 'hat_hair' },
    jokers = { 'j_jojoker_hat_hair' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        local chips_hand = 7 + G.jokers.cards[1].ability.extra.chips
        local mult_hand = 7 * (1 + G.jokers.cards[1].ability.extra.mult)
        local total = G.GAME.chips
        Balatest.assert(total == chips_hand * 2 or total == chips_hand + mult_hand or total == mult_hand * 2,
            "Hat Hair did not give chips or mult on both played hands, got "..tostring(total))
    end
}

Balatest.TestPlay {
    name = 'hat_hair_does_not_trigger_on_discard',
    category = { 'jokers', 'stardust_crusaders', 'hat_hair' },
    jokers = { 'j_jojoker_hat_hair' },
    execute = function()
        Balatest.discard { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(0, "Hat Hair gave a bonus without a hand being played")
    end
}
-- #endregion
