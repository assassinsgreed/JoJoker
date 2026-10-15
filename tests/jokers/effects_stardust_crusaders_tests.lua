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
-- #region Speedwagon Foundation Submarine
Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_gives_money_when_skipping_a_blind',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    dollars = 0,
    no_auto_start = true,
    execute = function()
        skip_blind_into_shop()
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money, "Speedwagon Foundation Submarine did not give money when skipping a blind")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_opens_the_shop_after_skipping_a_blind',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    no_auto_start = true,
    execute = function()
        skip_blind_into_shop()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.STATE, G.STATES.SHOP, "Speedwagon Foundation Submarine did not open the shop after skipping a blind")
        Balatest.assert(#G.shop_jokers.cards > 0, "Speedwagon Foundation Submarine opened a shop with no cards")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_returns_to_the_next_blind_after_the_shop',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    no_auto_start = true,
    execute = function()
        skip_blind_into_shop()
        Balatest.exit_shop()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.STATE, G.STATES.BLIND_SELECT, "Speedwagon Foundation Submarine did not return to blind select after the shop")
        Balatest.assert_eq(G.GAME.blind_on_deck, 'Big', "Speedwagon Foundation Submarine did not move on to the Big Blind after the shop")
        Balatest.assert_eq(G.GAME.round_resets.blind_states.Small, 'Skipped', "Speedwagon Foundation Submarine did not leave the Small Blind skipped")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_triggers_on_every_skipped_blind',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    dollars = 0,
    no_auto_start = true,
    execute = function()
        skip_blind_into_shop()
        Balatest.exit_shop()
        skip_blind_into_shop()
    end,
    assert = function()
        Balatest.assert_eq(G.STATE, G.STATES.SHOP, "Speedwagon Foundation Submarine did not open the shop after skipping the Big Blind")
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money * 2, "Speedwagon Foundation Submarine did not give money for both skipped blinds")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_waits_for_tag_booster_pack_before_shop',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    no_auto_start = true,
    execute = function()
        skip_blind_for_tag('tag_charm')
        Balatest.wait_for_input(G.STATES.SMODS_BOOSTER_OPENED)
        Balatest.q(function()
            G.FUNCS.skip_booster()
        end)
        Balatest.wait_for_input(G.STATES.SHOP)
    end,
    assert = function()
        Balatest.assert_eq(G.STATE, G.STATES.SHOP, "Speedwagon Foundation Submarine did not open the shop after the tag's booster pack")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_copies_give_money_but_open_one_shop',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_khnum', 'j_jojoker_speedwagon_foundation_submarine' },
    dollars = 0,
    no_auto_start = true,
    execute = function()
        skip_blind_into_shop()
        Balatest.exit_shop()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[2].ability.extra.money * 2, "Khnum did not copy Speedwagon Foundation Submarine's money")
        Balatest.assert_eq(G.STATE, G.STATES.BLIND_SELECT, "Speedwagon Foundation Submarine opened the shop more than once for one skip")
    end
}

Balatest.TestPlay {
    name = 'speedwagon_foundation_submarine_does_not_trigger_when_blind_is_played',
    category = { 'jokers', 'stardust_crusaders', 'speedwagon_foundation_submarine' },
    jokers = { 'j_jojoker_speedwagon_foundation_submarine' },
    dollars = 0,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Speedwagon Foundation Submarine gave money without a blind being skipped")
        Balatest.assert_eq(G.STATE, G.STATES.SELECTING_HAND, "Speedwagon Foundation Submarine left the blind without it being skipped")
    end
}
-- #endregion
