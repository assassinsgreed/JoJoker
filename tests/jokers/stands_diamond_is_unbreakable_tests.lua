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
--#region The Hand
Balatest.TestPlay {
    name = 'the_hand_debuffs_a_rank_on_blind_start',
    category = { 'jokers', 'diamond_is_unbreakable', 'the_hand' },
    jokers = { 'j_jojoker_the_hand' },
    execute = function()
        local debuffed_card_rank = nil
        for k, v in pairs(G.playing_cards) do
            if v.debuff then
                debuffed_card_rank = shorthand_rank_string_from_id(v:get_id())
                break
            end
        end
        Balatest.play_hand { debuffed_card_rank..'S' }
    end,
    assert = function()
        Balatest.assert_chips(5, "The Hand didn't debuff the played card")
    end
}
-- Fix
Balatest.TestPlay {
    name = 'the_hand_buffs_rank_on_either_side_of_debuffed_rank',
    category = { 'jokers', 'diamond_is_unbreakable', 'the_hand' },
    jokers = { 'j_jojoker_the_hand' },
    execute = function()
        local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
        local debuffed = G.jokers.cards[1].ability.extra.debuff_rank

        local debuffed_rank_index = nil
        for k, v in pairs(ranks) do
            if v == (debuffed:len() >= 3 and debuffed:sub(1, 1) or debuffed) then
                debuffed_rank_index = k
            break
            end
        end
        local low_rank = ranks[debuffed_rank_index - 1 >= 1 and debuffed_rank_index - 1 or #ranks]
        local high_rank = ranks[debuffed_rank_index + 1 <= #ranks and debuffed_rank_index + 1 or 1]
        Balatest.play_hand { low_rank..'S', low_rank..'C', high_rank..'D', high_rank..'H' }
    end,
    assert = function()
        Balatest.assert(G.GAME.chips > 1000, "The Hand didn't buff the ranks on either side of debuffed rank") -- Arbitrary assertion that scored chips exceed a threshold
    end
}
--#endregion
--#region Superfly
Balatest.TestPlay {
    name = 'superfly_disables_boss_blind_on_sell',
    category = { 'jokers', 'diamond_is_unbreakable', 'superfly' },
    jokers = { 'j_jojoker_superfly' },
    dollars = 10,
    blind = 'bl_wheel',
    execute = function()
        Balatest.assert_eq(G.GAME.blind.disabled, false, "Superfly didn't start on an enabled boss blind")
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.blind.disabled, true, "Superfly didn't disable boss blind on sell")
    end
}
--#endregion
--#region Crazy Diamond
Balatest.TestPlay {
    name = 'crazy_diamond_gives_no_mult_for_non_diamonds_cards',
    category = { 'jokers', 'diamond_is_unbreakable', 'crazy_diamond' },
    jokers = { 'j_jojoker_crazy_diamond' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Crazy Diamond incorrectly gave mult for non-diamonds card")
    end
}
Balatest.TestPlay {
    name = 'crazy_diamond_gives_mult_for_single_diamonds_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'crazy_diamond' },
    jokers = { 'j_jojoker_crazy_diamond' },
    execute = function()
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "Crazy Diamond incorrectly gave mult for single diamonds card")
    end
}
Balatest.TestPlay {
    name = 'crazy_diamond_gives_mult_for_each_scored_diamonds_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'crazy_diamond' },
    jokers = { 'j_jojoker_crazy_diamond' },
    execute = function()
        Balatest.play_hand { '2D', '3D', '5D', '7D', '8D' }
    end,
    assert = function()
        Balatest.assert_chips(60 * (G.jokers.cards[1].ability.extra.mult * 5 + 4), "Crazy Diamond incorrectly gave mult for multiple scored diamonds cards")
    end
}
--#endregion
--#region Bad Company
Balatest.TestPlay {
    name = 'bad_company_gives_no_mult_if_deck_size_is_same_as_starting_deck_size',
    category = { 'jokers', 'diamond_is_unbreakable', 'bad_company' },
    jokers = { 'j_jojoker_bad_company' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Bad Company incorrectly gave mult for deck size same as starting deck size")
    end
}
Balatest.TestPlay {
    name = 'bad_company_gives_mult_if_deck_size_exceeds_starting_deck_size',
    category = { 'jokers', 'diamond_is_unbreakable', 'bad_company' },
    jokers = { 'j_jojoker_bad_company' },
    execute = function()
        for i = 1, 2 do
            local copy = copy_card(G.hand.cards[1], nil, nil, G.playing_card)
            copy:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, copy)
            G.deck:emplace(copy)
        end
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult * 2 + 1), "Bad Company did not give mult when deck size exceeded starting deck size")
    end
}
--#endregion
--#region Cheap Trick
Balatest.TestPlay {
    name = 'cheap_trick_gives_default_xmult_when_no_jokers_destroyed',
    category = { 'jokers', 'diamond_is_unbreakable', 'cheap_trick' },
    jokers = { 'j_jojoker_cheap_trick' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Cheap Trick did not give correct xmult when no jokers were destroyed")
    end
}
Balatest.TestPlay {
    name = 'cheap_trick_gives_xmult_for_each_joker_destroyed',
    category = { 'jokers', 'diamond_is_unbreakable', 'cheap_trick' },
    jokers = { 'j_jojoker_cheap_trick', 'j_jojoker_crazy_diamond' },
    execute = function()
        SMODS.destroy_cards(G.jokers.cards[2])
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * G.jokers.cards[1].ability.extra.Xmult, "Cheap Trick did not give correct xmult when a joker was destroyed")
    end
}
--#endregion
--#region Cinderella
Balatest.TestPlay {
    name = 'cinderella_converts_first_scored_card_into_queen_or_king',
    category = { 'jokers', 'diamond_is_unbreakable', 'cinderella' },
    jokers = { 'j_jojoker_cinderella' },
    deck = { cards = {
        { r = '5', s = 'H' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { '5H' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queen_or_king_count = 0
        for _, v in pairs(G.deck.cards) do
            if v:get_id() == 12 or v:get_id() == 13 then
                queen_or_king_count = queen_or_king_count + 1
            end
        end
        Balatest.assert_eq(queen_or_king_count, 1, "Cinderella did not convert exactly one scored card into Queen or King")
    end
}

Balatest.TestPlay {
    name = 'cinderella_does_not_convert_first_scored_queen',
    category = { 'jokers', 'diamond_is_unbreakable', 'cinderella' },
    jokers = { 'j_jojoker_cinderella' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'C' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'QS' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queen_or_king_count = 0
        for _, v in pairs(G.deck.cards) do
            if v:get_id() == 12 or v:get_id() == 13 then
                queen_or_king_count = queen_or_king_count + 1
            end
        end
        Balatest.assert_eq(queen_or_king_count, 1, "Cinderella converted cards when only Queens or Kings were scored")
    end
}

Balatest.TestPlay {
    name = 'cinderella_does_not_convert_cards_on_subsequent_hands',
    category = { 'jokers', 'diamond_is_unbreakable', 'cinderella' },
    jokers = { 'j_jojoker_cinderella' },
    deck = { cards = {
        { r = 'Q', s = 'S' },
        { r = 'J', s = 'C' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { 'QS' }
        Balatest.play_hand { '2H' }
        Balatest.end_round() -- End round to return cards to deck
    end,
    assert = function()
        local queen_or_king_count = 0
        for _, v in pairs(G.deck.cards) do
            if v:get_id() == 12 or v:get_id() == 13 then
                queen_or_king_count = queen_or_king_count + 1
            end
        end
        Balatest.assert_eq(queen_or_king_count, 1, "Cinderella converted cards after first hand was played")
    end
}
--#endregion

--#region Atom Heart Father
Balatest.TestPlay {
    name = 'atom_heart_father_gives_xmult_for_each_seal_in_deck',
    category = { 'jokers', 'diamond_is_unbreakable', 'atom_heart_father' },
    jokers = { 'j_jojoker_atom_heart_father' },
    execute = function()
        G.hand.cards[1].seal = 'Red' -- Manually give non-gold seal to queen to test that gold seal is not given
        Balatest.wait()
    end,
    assert = function()
        local xmult = G.jokers.cards[1].ability.extra.Xmult
        Balatest.assert_eq(xmult, 1 + G.jokers.cards[1].ability.extra.Xmult_mod, "Atom Heart Father did not give correct XMult for each seal in deck")
    end
}
--#endregion