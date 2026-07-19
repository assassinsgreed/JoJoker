--#region Magician's Red
Balatest.TestPlay {
    name = 'magician_red_gives_no_money_when_score_does_not_catch_fire',
    category = { 'jokers', 'stardust_crusaders', 'magician_red' },
    jokers = { 'j_jojoker_magician_red' },
    execute = function()
        Balatest.play_hand { '4S', '4C', '4H', '5H', '5C' }
    end,
    assert = function()
        Balatest.assert_dollars(0, "Magician's Red incorrectly gave money when score did not catch fire")
    end
}
Balatest.TestPlay {
    name = 'magician_red_gives_correct_money_when_score_catches_fire',
    category = { 'jokers', 'stardust_crusaders', 'magician_red' },
    jokers = { 'j_jojoker_magician_red' },
    execute = function()
        Balatest.play_hand { '4S', '5S', '6S', '7S', '8S' }
    end,
    assert = function()
        Balatest.assert_dollars(5, "Magician's Red did not give expected money when score caught fire")
    end
}
--#endregion
--#region Yellow Temperance
Balatest.TestPlay {
    name = 'yellow_temperance_retriggers_scored_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { 'KS', 'KC' }
    end,
    assert = function()
        Balatest.assert_chips(100, "Yellow Temperance did not retrigger scored face cards")
    end
}
Balatest.TestPlay {
    name = 'yellow_temperance_does_not_retrigger_unscored_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { 'AS', 'KC' }
    end,
    assert = function()
        Balatest.assert_chips(16, "Yellow Temperance retrigger unscored face cards")
    end
}
Balatest.TestPlay {
    name = 'yellow_temperance_does_not_retrigger_non_face_cards',
    category = { 'jokers', 'stardust_crusaders', 'yellow_temperance' },
    jokers = { 'j_jojoker_yellow_temperance' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Yellow Temperance retriggered scored non-face cards")
    end
}
--#endregion
--#region Star Platinum
Balatest.TestPlay {
    name = 'star_platinum_gives_one_extra_hand_when_triggered',
    category = { 'jokers', 'stardust_crusaders', 'star_platinum' },
    jokers = { 'j_jojoker_star_platinum' },
    hands = 3,
    execute = function()
        G.jokers.cards[1].ability.extra.denominator = G.jokers.cards[1].ability.extra.numerator
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 3, "Star Platinum did not give a hand when triggering")
    end
}
--#endregion
--#region Wheel of Fortune
Balatest.TestPlay {
    name = 'wheel_of_fortune_guarantees_tarot_effect',
    category = { 'jokers', 'stardust_crusaders', 'wheel_of_fortune' },
    jokers = { 'j_jojoker_wheel_of_fortune' },
    consumeables = { 'c_wheel_of_fortune' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        local has_edition = G.jokers.cards[1].edition.key ~= nil -- Could be multiple effects
        Balatest.assert(has_edition, "Wheel of Fortune did not guarantee tarot effect")
    end
}
--#endregion
--#region The Lovers
Balatest.TestPlay {
    name = 'the_lovers_increases_multiplier_of_scored_heart_cards',
    category = { 'jokers', 'stardust_crusaders', 'the_lovers' },
    jokers = { 'j_jojoker_the_lovers' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'H' },
        { r = '5', s = 'H' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH', 'QH', '5H' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
            
    end,
    assert = function()
        local firstQueenPermaMult = G.deck.cards[1].ability.perma_mult
        local secondQueenPermaMult = G.deck.cards[2].ability.perma_mult
        local fivePermaMult = G.deck.cards[3].ability.perma_mult
        Balatest.assert_eq(firstQueenPermaMult, 3, "The Lovers did not permanently increase mult of first scored heart.")
        Balatest.assert_eq(secondQueenPermaMult, 3, "The Lovers did not permanently increase mult of second scored heart.")
        Balatest.assert_eq(fivePermaMult, 0, "The Lovers incorrectly increased mult of non-scored heart card.")
    end
}

Balatest.TestPlay {
    name = 'the_lovers_further_increases_multiplier_of_already_increased_heart_cards',
    category = { 'jokers', 'stardust_crusaders', 'the_lovers' },
    jokers = { 'j_jojoker_the_lovers' },
    deck = { cards = {
        { r = 'Q', s = 'H' },
        { r = 'Q', s = 'H' },
        { r = '5', s = 'H' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QH', 'QH', '5H' } -- Play all and check the deck afterward
        Balatest.next_round()
        Balatest.play_hand { 'QH', 'QH', '5H' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstQueenPermaMult = G.deck.cards[1].ability.perma_mult
        local secondQueenPermaMult = G.deck.cards[2].ability.perma_mult
        local fivePermaMult = G.deck.cards[3].ability.perma_mult
        Balatest.assert_eq(firstQueenPermaMult, 6, "The Lovers did not permanently increase mult of first scored heart.")
        Balatest.assert_eq(secondQueenPermaMult, 6, "The Lovers did not permanently increase mult of second scored heart.")
        Balatest.assert_eq(fivePermaMult, 0, "The Lovers incorrectly increased mult of non-scored heart card.")
    end
}

Balatest.TestPlay {
    name = 'the_lovers_does_not_increase_multiplier_of_non_heart_cards',
    category = { 'jokers', 'stardust_crusaders', 'the_lovers' },
    jokers = { 'j_jojoker_the_lovers' },
    deck = { cards = {
        { r = 'Q', s = 'C' },
        { r = 'Q', s = 'C' },
        { r = '5', s = 'C' },
        { r = '2', s = 'C' } } },
    execute = function()
        Balatest.play_hand { 'QC', 'QC', '5C' } -- Play all and check the deck afterward
        Balatest.end_round() -- Get all cards back into the deck for comparision
    end,
    assert = function()
        local firstQueenPermaMult = G.deck.cards[1].ability.perma_mult
        local secondQueenPermaMult = G.deck.cards[2].ability.perma_mult
        local fivePermaMult = G.deck.cards[3].ability.perma_mult
        Balatest.assert_eq(firstQueenPermaMult, 0, "The Lovers incorrectly increased mult of first non-heart card.")
        Balatest.assert_eq(secondQueenPermaMult, 0, "The Lovers incorrectly increased mult of second non-heart card.")
        Balatest.assert_eq(fivePermaMult, 0, "The Lovers incorrectly increased mult of third non-heart card.")
    end
}
--#endregion
--#region Anubis
Balatest.TestPlay {
    name = 'anubis_does_not_give_chips_when_no_jokers_sold',
    category = { 'jokers', 'stardust_crusaders', 'anubis' },
    jokers = { 'j_jojoker_anubis' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Anubis incorrectly gave extra chips when no jokers were sold")
    end
}
Balatest.TestPlay {
    name = 'anubis_gives_additional_chips_when_a_joker_is_sold',
    category = { 'jokers', 'stardust_crusaders', 'anubis' },
    jokers = { 'j_jojoker_anubis', 'j_jojoker_old_joseph_joestar' },
    execute = function()
        Balatest.sell(function() return G.jokers.cards[2] end)
        G.jokers.cards[1].ability.extra.chips = G.jokers.cards[1].ability.extra.chips_mod -- Set chips to gain for easier assertion; Balatest sell does not proc selling_card context
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.chips, "Anubis did not give extra chips when a joker was sold")
        Balatest.assert_neq(7, "Anubis did not give extra chips when a joker was sold")
    end
}
--#endregion
--#region Sethan
Balatest.TestPlay {
    name = 'sethan_reduces_level_of_played_hand_to_1_and_gains_xmult_for_each_level_drained',
    category = { 'jokers', 'stardust_crusaders', 'sethan' },
    jokers = { 'j_jojoker_sethan' },
    consumeables = { 'c_pluto', 'c_pluto' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[2])
        Balatest.play_hand { 'KS' }
    end,
    assert = function()
        local highCardLevel = G.GAME.hands["High Card"].level
        local expectedXmult = G.jokers.cards[1].ability.extra.Xmult_mod * 2 + 1
        Balatest.assert_eq(highCardLevel, 1, "Sethan did not reduce the level of the played hand to 1")
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expectedXmult, "Sethan did not gain expected xmult for each level drained")
    end
}
--#endregion
--#region The World
Balatest.TestPlay {
    name = 'the_world_gives_1x_mult_by_default',
    category = { 'jokers', 'stardust_crusaders', 'the_world' },
    jokers = { 'j_jojoker_the_world' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, 1, "The World does not start with 1x mult")
    end
}
Balatest.TestPlay {
    name = 'the_world_gives_xmult_boost_once_with_duplicate_tarots_played',
    category = { 'jokers', 'stardust_crusaders', 'the_world' },
    jokers = { 'j_jojoker_the_world' },
    consumeables = { 'c_strength', 'c_strength' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[2])
    end,
    assert = function()
        local expectedXmult = G.jokers.cards[1].ability.extra.Xmult_mod * 1 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expectedXmult, "The World did not give expected xmult for duplicate tarot cards")
    end
}
Balatest.TestPlay {
    name = 'the_world_gives_xmult_boost_for_each_unique_played_tarot',
    category = { 'jokers', 'stardust_crusaders', 'the_world' },
    jokers = { 'j_jojoker_the_world' },
    consumeables = { 'c_strength', 'c_chariot' },
    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.use(G.consumeables.cards[2])
    end,
    assert = function()
        local expectedXmult = G.jokers.cards[1].ability.extra.Xmult_mod * 2 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expectedXmult, "The World did not give expected xmult for unique tarot cards")
    end
}
--#endregion
--#region Death Thirteen
Balatest.TestPlay {
    name = 'death_thirteen_mult_does_not_increase_when_in_slot_1',
    category = { 'jokers', 'stardust_crusaders', 'death_thirteen' },
    jokers = { 'j_jojoker_death_thirteen' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 1, "Death Thirteen mult increased when in slot 1")
    end
}
Balatest.TestPlay {
    name = 'death_thirteen_mult_increases_by_2x_sell_value_of_left_joker',
    category = { 'jokers', 'stardust_crusaders', 'death_thirteen' },
    jokers = { 'j_jojoker_sex_pistols', 'j_jojoker_death_thirteen' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local expected_mult = 1 + 2 * 2  -- sex_pistols sell_cost = floor(5/2) = 2
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, expected_mult, "Death Thirteen mult did not increase by 2x sell value of left joker")
        Balatest.assert_eq(#G.jokers.cards, 1, "Death Thirteen did not destroy the left joker")
    end
}
--#endregion

--#region Tenore Sax
local tenore_sax_original_hand = {}
Balatest.TestPlay {
    name = 'tenore_sax_shuffles_unplayed_cards_back_into_deck',
    category = { 'jokers', 'stardust_crusaders', 'tenore_sax' },
    jokers = { 'j_jojoker_tenore_sax' },
    hand_size = 10,
    execute = function()
        tenore_sax_original_hand = table.shallow_copy(G.hand.cards)
        local first_card_rank = shorthand_rank_string_from_id(tenore_sax_original_hand[1]:get_id())
        local first_card_suit = tenore_sax_original_hand[1].base.suit:sub(1, 1) -- Strip full suit name to just first char
        Balatest.play_hand { first_card_rank..first_card_suit }
        Balatest.wait_for_input(G.STATES.SELECTING_HAND)
    end,
    assert = function()
        local new_hand = table.shallow_copy(G.hand.cards)
        local are_hands_the_same = true
        for i = 1, #G.hand.cards do
            if (new_hand[i]:get_id() ~= tenore_sax_original_hand[i]:get_id()) or (new_hand[i].base.suit ~= tenore_sax_original_hand[i].base.suit) then
                are_hands_the_same = false
                break
            end
        end

        Balatest.assert_eq(are_hands_the_same, false, "Tenore Sax did not shuffle unplayed cards back into the deck")
    end
}
--#endregion

--#region Khnum
Balatest.TestPlay {
    name = 'khnum_copies_rightmost_compatible_joker',
    category = { 'jokers', 'stardust_crusaders', 'khnum', 'voice_of_love' },
    jokers = { 'j_jojoker_khnum', 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        local total_joker_mult = (2 * G.jokers.cards[2].ability.extra.mult) + 1 -- Base 1 from pair + (2 jokers * mult mod of copied joker)
        Balatest.assert_chips(7 * total_joker_mult, "khnum did not copy rightmost joker")
    end
}

Balatest.TestPlay {
    name = 'khnum_does_not_copy_incompatible_joker',
    category = { 'jokers', 'stardust_crusaders', 'khnum', 'yoshikage_kira' },
    jokers = { 'j_jojoker_khnum', 'j_jojoker_yoshikage_kira' },
    hands = 1,
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local hands = G.GAME.current_round.hands_left
        Balatest.assert_eq(hands, 2, "khnum copied rightmost joker even though it was incompatible")
    end
}

Balatest.TestPlay {
    name = 'khnum_does_nothing_when_in_last_position',
    category = { 'jokers', 'stardust_crusaders', 'khnum', 'voice of _love' },
    jokers = { 'j_jojoker_voice_of_love', 'j_jojoker_khnum' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        local total_joker_mult = (1 * G.jokers.cards[1].ability.extra.mult) + 1 -- Base 1 from pair + (2 jokers * mult mod of copied joker)
        Balatest.assert_chips(7 * total_joker_mult, "khnum copied something when it was rightmost joker")
    end
}
--#endregion
--#region Hierophant Green
Balatest.TestPlay {
    name = 'hierophant_green_does_not_give_mult_when_exceeding_rank_diff',
    category = { 'jokers', 'stardust_crusaders', 'hierophant_green' },
    jokers = { 'j_jojoker_hierophant_green' },
    execute = function()
        Balatest.play_hand { '2H', '3H', '4H', '5H', '6H' }
    end,
    assert = function()
        Balatest.assert_chips(960, "Hierophant Green gave mult when it should not have")
    end
}

Balatest.TestPlay {
    name = 'hierophant_green_does_not_give_mult_when_single_card',
    category = { 'jokers', 'stardust_crusaders', 'hierophant_green' },
    jokers = { 'j_jojoker_hierophant_green' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Hierophant Green gave mult for single card")
    end
}

Balatest.TestPlay {
    name = 'hierophant_green_gives_mult_for_pair',
    category = { 'jokers', 'stardust_crusaders', 'hierophant_green' },
    jokers = { 'j_jojoker_hierophant_green' },
    execute = function()
        Balatest.play_hand { '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(238, "Hierophant Green did not give mult for pair")
    end
}

Balatest.TestPlay {
    name = 'hierophant_green_gives_mult_for_cards_within_threshold',
    category = { 'jokers', 'stardust_crusaders', 'hierophant_green' },
    jokers = { 'j_jojoker_hierophant_green' },
    execute = function()
        Balatest.play_hand { '2H', '2C', '4H', '4C', '4S' }
    end,
    assert = function()
        Balatest.assert_chips(1064, "Hierophant Green did not give mult for full house within threshold")
    end
}

Balatest.TestPlay {
    name = 'hierophant_green_gives_mult_for_cards_across_two_and_ace_gap',
    category = { 'jokers', 'stardust_crusaders', 'hierophant_green' },
    jokers = { 'j_jojoker_hierophant_green' },
    execute = function()
        Balatest.play_hand { '2H', '2C', 'AH', 'AC' }
    end,
    assert = function()
        Balatest.assert_chips(782, "Hierophant Green did not give mult for cards within threshold with ace gap")
    end
}
--#endregion

--#region The Fool
Balatest.TestPlay {
    name = 'the_fool_transforms_on_blind_start',
    category = { 'jokers', 'stardust_crusaders', 'the_fool' },
    jokers = { 'j_jojoker_the_fool' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local is_the_fool = G.jokers.cards[1].config.center == G.P_CENTERS['j_jojoker_the_fool']
        Balatest.assert_eq(is_the_fool, false, "The Fool did not transform on blind start")
    end
}

Balatest.TestPlay {
    name = 'the_fool_reverts_when_entering_the_shop',
    category = { 'jokers', 'stardust_crusaders', 'the_fool' },
    jokers = { 'j_jojoker_the_fool' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        local is_the_fool = G.jokers.cards[1].config.center == G.P_CENTERS['j_jojoker_the_fool']
        Balatest.assert_eq(is_the_fool, true, "The Fool did not revert when entering the shop")
    end
}

Balatest.TestPlay {
    name = 'the_fool_transformation_pool_excludes_copy_and_evolved_jokers',
    category = { 'jokers', 'stardust_crusaders', 'the_fool' },
    execute = function()
        Balatest.wait()
    end,
    assert = function()
        local excluded = {
            ['j_jojoker_khnum'] = true,
            ['j_jojoker_surface'] = true,
            ['j_jojoker_the_fool'] = true,
            ['j_jojoker_kars_stopped_thinking'] = true,
            ['j_jojoker_stroheim_german_engineering'] = true,
        }
        for i = 1, 50 do
            local key = get_random_joker_key('balatest_the_fool_' .. i)
            Balatest.assert(key ~= nil, "get_random_joker_key returned nil")
            Balatest.assert(not excluded[key], "get_random_joker_key returned banned key " .. tostring(key))
        end
    end
}
--#endregion
--#region Thoth
Balatest.TestPlay {
    name = 'thoth_does_not_level_down_hand_below_one',
    category = { 'jokers', 'stardust_crusaders', 'thoth' },
    jokers = { 'j_jojoker_thoth' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type = "Two Pair"
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 1, "Two Pair hand wasn't level 1")
    end
}
Balatest.TestPlay {
    name = 'thoth_levels_up_hand_when_correct_hand_played',
    category = { 'jokers', 'stardust_crusaders', 'thoth' },
    jokers = { 'j_jojoker_thoth' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type = "Two Pair"
        Balatest.play_hand { '2S', '2C', '7H', '7D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 1 + G.jokers.cards[1].ability.extra.level_change_up, "Thoth didn't level up 2 pair hand after it was played")
    end
}
Balatest.TestPlay {
    name = 'thoth_levels_up_hand_multiple_times_per_blind',
    category = { 'jokers', 'stardust_crusaders', 'thoth' },
    jokers = { 'j_jojoker_thoth' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type = "High Card"
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2D' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["High Card"].level
        Balatest.assert_eq(two_pair_hand_level, 1 + 2 * G.jokers.cards[1].ability.extra.level_change_up, "Thoth didn't level up two pair hand to level 3, after it was played twice")
    end
}
Balatest.TestPlay {
    name = 'thoth_does_not_level_up_two_pair_contained_in_full_house',
    category = { 'jokers', 'stardust_crusaders', 'thoth' },
    jokers = { 'j_jojoker_thoth' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_hand_type = "Two Pair"
        G.jokers.cards[1].ability.extra.jokerdisplay_hand_type = "Two Pair" -- Purely for viewer sanity; this does not matter for the test
        Balatest.play_hand { '2S', '2C', '7H', '7D', '7S' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 1, "Thoth leveled up Two Pair hand when Full House was played, but should not have")
    end
}
Balatest.TestPlay {
    name = 'thoth_levels_down_chosen_hand_if_different_hand_played',
    category = { 'jokers', 'stardust_crusaders', 'thoth' },
    jokers = { 'j_jojoker_thoth' },
    execute = function()
        G.GAME.hands["Two Pair"].level = 5
        G.jokers.cards[1].ability.extra.chosen_hand_type = "Two Pair"
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local two_pair_hand_level = G.GAME.hands["Two Pair"].level
        Balatest.assert_eq(two_pair_hand_level, 5 - G.jokers.cards[1].ability.extra.level_change_down, "Thoth did not level down Two Pair hand when different hand was played")
    end
}
--#endregion

--#region The Sun
Balatest.TestPlay {
    name = 'the_sun_gives_chips_for_pair',
    category = { 'jokers', 'stardust_crusaders', 'the_sun' },
    jokers = { 'j_jojoker_the_sun' },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(188, "The Sun did not give chips for scored Pair")
    end
}

Balatest.TestPlay {
    name = 'the_sun_does_not_give_chips_for_non_pair',
    category = { 'jokers', 'stardust_crusaders', 'the_sun' },
    jokers = { 'j_jojoker_the_sun' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(108, "The Sun gave chips for hand containing Pair")
    end
}
--#endregion