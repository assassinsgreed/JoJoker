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