--#region Voice of Love

Balatest.TestPlay {
    name = 'voice_of_love_gives_no_mult_for_non_heart_cards',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Voice of Love incorrectly gave mult for non-heart card")
    end
}

Balatest.TestPlay {
    name = 'voice_of_love_gives_mult_for_single_heart_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(7 * (G.jokers.cards[1].ability.extra.mult + 1), "Voice of Love incorrectly gave mult for single heart card")
    end
}

Balatest.TestPlay {
    name = 'voice_of_love_gives_mult_for_each_scored_heart_card',
    category = { 'jokers', 'diamond_is_unbreakable', 'voice_of_love' },
    jokers = { 'j_jojoker_voice_of_love' },
    execute = function()
        Balatest.play_hand { '2H', '3H', '5H', '7H', '8H' }
    end,
    assert = function()
        Balatest.assert_chips(60 * (G.jokers.cards[1].ability.extra.mult * 5 + 4), "Voice of Love incorrectly gave mult for multiple scored heart cards")
    end
}

--#endregion

--#region Ghost Girl Alley

-- The way Balatest invokes blinds prevents boss blinds from being seen as bosses, so antes cleared are set directly
Balatest.TestPlay {
    name = 'ghost_girl_alley_gives_nothing_with_no_antes_cleared',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Ghost Girl Alley gave chips or mult with no antes cleared")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_gives_chips_and_mult_for_each_ante_cleared',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    execute = function()
        Balatest.q(function() G.GAME.jojoker_bosses_beaten = 3 end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_chips((7 + 3 * extra.chips_mod) * (1 + 3 * extra.mult_mod), "Ghost Girl Alley did not give chips and mult for each ante cleared")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_gives_money_for_each_ante_cleared_at_end_of_round',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    execute = function()
        Balatest.q(function() G.GAME.jojoker_bosses_beaten = 3 end)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_dollars(3 * G.jokers.cards[1].ability.extra.money_mod, "Ghost Girl Alley did not give money for each ante cleared")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_does_not_count_non_boss_blinds_as_antes_cleared',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    blind = 'bl_small',
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.jojoker_bosses_beaten or 0, 0, "Ghost Girl Alley counted a non-Boss blind as an ante cleared")
    end
}

-- Killer Queen reverses the ante through the same ease_ante call
Balatest.TestPlay {
    name = 'ghost_girl_alley_destroyed_when_ante_reversed',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    execute = function()
        Balatest.q(function() ease_ante(-1) end)
        Balatest.wait(2)
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0, "Ghost Girl Alley was not destroyed when the ante was reversed")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_not_destroyed_when_ante_advances',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    execute = function()
        Balatest.q(function() ease_ante(1) end)
        Balatest.wait(2)
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 1, "Ghost Girl Alley was destroyed when the ante advanced")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_destroyed_by_hieroglyph',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.redeem(function()
            local voucher = G.shop_vouchers.cards[1]
            voucher:set_ability(G.P_CENTERS.v_hieroglyph)
            voucher.cost = 0
            return voucher
        end)
        Balatest.wait(2)
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0, "Ghost Girl Alley was not destroyed when Hieroglyph reversed the ante")
    end
}

Balatest.TestPlay {
    name = 'ghost_girl_alley_destroyed_by_petroglyph',
    category = { 'jokers', 'diamond_is_unbreakable', 'ghost_girl_alley' },
    jokers = { 'j_jojoker_ghost_girl_alley' },
    dollars = 10,
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.redeem(function()
            local voucher = G.shop_vouchers.cards[1]
            voucher:set_ability(G.P_CENTERS.v_petroglyph)
            voucher.cost = 0
            return voucher
        end)
        Balatest.wait(2)
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0, "Ghost Girl Alley was not destroyed when Petroglyph reversed the ante")
    end
}

--#endregion
--#region Earth, Wind, and Fire

Balatest.TestPlay {
    name = 'earth_wind_and_fire_lets_owned_jokers_appear_again',
    category = { 'jokers', 'diamond_is_unbreakable', 'earth_wind_and_fire' },
    jokers = { 'j_jojoker_earth_wind_and_fire', 'j_jojoker_voice_of_love' },
    assert = function()
        Balatest.assert(pool_offers('Joker', 'j_jojoker_voice_of_love', 'Common'), "Earth, Wind, and Fire did not let an owned joker appear in the pool again")
    end
}

Balatest.TestPlay {
    name = 'earth_wind_and_fire_lets_used_consumables_appear_again',
    category = { 'jokers', 'diamond_is_unbreakable', 'earth_wind_and_fire' },
    jokers = { 'j_jojoker_earth_wind_and_fire' },
    execute = function()
        G.GAME.used_jokers['c_fool'] = true
        G.GAME.used_jokers['c_mars'] = true
        G.GAME.used_jokers['c_familiar'] = true
    end,
    assert = function()
        Balatest.assert(pool_offers('Tarot', 'c_fool'), "Earth, Wind, and Fire did not let a used tarot appear again")
        Balatest.assert(pool_offers('Planet', 'c_mars'), "Earth, Wind, and Fire did not let a used planet appear again")
        Balatest.assert(pool_offers('Spectral', 'c_familiar'), "Earth, Wind, and Fire did not let a used spectral appear again")
    end
}

Balatest.TestPlay {
    name = 'owned_jokers_do_not_appear_again_without_earth_wind_and_fire',
    category = { 'jokers', 'diamond_is_unbreakable', 'earth_wind_and_fire' },
    jokers = { 'j_jojoker_voice_of_love' },
    assert = function()
        Balatest.assert(not pool_offers('Joker', 'j_jojoker_voice_of_love', 'Common'), "An owned joker appeared in the pool again without Earth, Wind, and Fire")
    end
}

Balatest.TestPlay {
    name = 'earth_wind_and_fire_does_not_allow_duplicates_while_debuffed',
    category = { 'jokers', 'diamond_is_unbreakable', 'earth_wind_and_fire' },
    jokers = { 'j_jojoker_earth_wind_and_fire', 'j_jojoker_voice_of_love' },
    execute = function()
        G.jokers.cards[1]:set_debuff(true)
    end,
    assert = function()
        Balatest.assert(not pool_offers('Joker', 'j_jojoker_voice_of_love', 'Common'), "A debuffed Earth, Wind, and Fire still let an owned joker appear again")
    end
}

--#endregion
