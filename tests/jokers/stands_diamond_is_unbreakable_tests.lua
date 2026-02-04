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
Balatest.TestPlay {
    name = 'the_hand_buffs_rank_on_either_side_of_debuffed_rank',
    category = { 'jokers', 'diamond_is_unbreakable', 'the_hand' },
    jokers = { 'j_jojoker_the_hand' },
    execute = function()
        local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
        local debuffed_card_rank = nil
        for k, v in pairs(G.playing_cards) do
            if v.debuff then
                debuffed_card_rank = shorthand_rank_string_from_id(v:get_id())
                break
            end
        end

        local debuffed_rank_index = nil
        for k, v in pairs(ranks) do
            if v == debuffed_card_rank then
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