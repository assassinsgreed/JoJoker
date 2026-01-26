--#region Sex Pistols
Balatest.TestPlay {
    name = 'sex_pistols_no_mult_when_invalid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        Balatest.play_hand { '4S' }
    end,
    assert = function()
        Balatest.assert_chips(9)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0, "Sex Pistols mult wasn't 0 when no valid rank present")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_correctly_based_on_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(96)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing a 7 and a 2")
    end
}
Balatest.TestPlay {
    name = 'sex_pistols_mult_increases_only_for_first_instance_of_valid_rank',
    category = { 'jokers', 'golden_wind', 'sex_pistols' },
    jokers = { 'j_jojoker_sex_pistols' },
    execute = function()
        G.jokers.cards[1].ability.extra.chosen_rank = "7"
        Balatest.play_hand { '7S', '7C' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 7, "Sex Pistols mult wasn't 7 after playing two 7s")
    end
}
--#endregion
--#region Spice Girl
Balatest.TestPlay {
    name = 'spice_girl_increases_chips_for_each_scored_stone_cards',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_stone' },
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_chips = G.jokers.cards[1].ability.extra.chips_mod * 2
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, expected_chips, "Spice Girl chips wasn't "..expected_chips.." after playing two stone cards")
    end
}
Balatest.TestPlay {
    name = 'spice_girl_increases_xmult_for_single_scored_steel_card',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '3', s = 'C', e = 'm_steel' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        local expected_xmult = G.jokers.cards[1].ability.extra.Xmult_mod + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Spice Girl xmult wasn't "..expected_xmult.." after scoring one steel card")
    end
}
Balatest.TestPlay {
    name = 'spice_girl_increases_xmult_for_each_scored_steel_cards',
    category = { 'jokers', 'golden_wind', 'spice_girl' },
    jokers = { 'j_jojoker_spice_girl' },
    deck = { cards = {
        { r = '2', s = 'S', e = 'm_steel' },
        { r = '2', s = 'C', e = 'm_steel' },
        { r = '2', s = 'H' } } },
    execute = function()
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local expected_xmult = G.jokers.cards[1].ability.extra.Xmult_mod * 2 + 1
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.Xmult, expected_xmult, "Spice Girl xmult wasn't "..expected_xmult.." after scoring one steel card")
    end
}
--#endregion