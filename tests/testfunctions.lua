-- Shared helpers for Balatest tests

count_sugar_mountains = function()
    local count = 0
    for _, joker in ipairs(G.jokers.cards) do
        if joker.ability.name == 'sugar_mountain' then
            count = count + 1
        end
    end
    return count
end

count_playing_cards = function(rank, suit)
    local count = 0
    for _, c in ipairs(G.playing_cards) do
        if c.base.value == rank and (not suit or c.base.suit == suit) then
            count = count + 1
        end
    end
    return count
end

debuff_playing_cards = function(rank, suit)
    for _, c in ipairs(G.playing_cards) do
        if c.base.value == rank and (not suit or c.base.suit == suit) then
            SMODS.debuff_card(c, true, 'balatest')
        end
    end
end

force_hat_hair_roll = function(roll)
    local original_pseudorandom = pseudorandom
    pseudorandom = function(seed, ...)
        if seed == 'hat_hair' then return roll end
        return original_pseudorandom(seed, ...)
    end
    return function() pseudorandom = original_pseudorandom end
end

notorious_big_xmult = function()
    return G.P_CENTERS.j_jojoker_notorious_big.config.extra.Xmult
end

free_shop_items = function(area)
    local free = {}
    for _, item in ipairs(area and area.cards or {}) do
        if item.ability.couponed and item.cost == 0 then free[#free + 1] = item end
    end
    return free
end

free_shop_item_count = function()
    return #free_shop_items(G.shop_jokers) + #free_shop_items(G.shop_booster)
end

reroll_shop_for_free = function()
    Balatest.q(function()
        G.GAME.current_round.free_rerolls = 1
        G.FUNCS.reroll_shop()
    end)
    Balatest.wait_for_input()
end

-- Balatest.skip_blind waits for blind select, which never returns when the skip opens a pack or the shop
skip_blind_for_tag = function(tag)
    Balatest.wait_for_input(G.STATES.BLIND_SELECT)
    Balatest.q(function()
        G.FUNCS.skip_blind { UIBox = { get_UIE_by_ID = function() return { config = { ref_table = Tag(tag) } } end } }
    end)
end

skip_blind_into_shop = function()
    skip_blind_for_tag('tag_double')
    Balatest.wait_for_input(G.STATES.SHOP)
end

-- Balatest cannot enter a blind that counts as a boss, so the flag is set before the round ends
end_boss_round = function()
    Balatest.q(function() G.GAME.blind.boss = true end)
    Balatest.end_round()
    Balatest.wait(1)
end

force_d4c_replacement = function(key)
    Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, key_append, ...)
        if key_append == 'd4c' then forced_key = key end
        return orig(t, a, l, r, k, s, forced_key, key_append, ...)
    end)
end

make_consumeable_negative = function(index)
    Balatest.q(function() G.consumeables.cards[index]:set_edition('e_negative', true, true) end)
    Balatest.wait()
end

-- Overwrites cards from the bottom of the area up, so a deck's draw order stays deterministic
set_card_bases = function(area, keys)
    for i, key in ipairs(keys) do
        area.cards[i]:set_base(G.P_CARDS[key])
    end
end

count_cards_in_area = function(area, rank_id)
    local count = 0
    for _, c in ipairs(area.cards) do
        if c:get_id() == rank_id then
            count = count + 1
        end
    end
    return count
end
