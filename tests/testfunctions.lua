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

find_playing_card = function(rank, suit)
    for _, c in ipairs(G.playing_cards) do
        if c.base.value == rank and c.base.suit == suit then
            return c
        end
    end
end

count_enhanced_playing_cards = function(center_key)
    local count = 0
    for _, c in ipairs(G.playing_cards) do
        if (center_key and c.config.center == G.P_CENTERS[center_key]) or (not center_key and c.ability.set == 'Enhanced') then
            count = count + 1
        end
    end
    return count
end

count_sealed_playing_cards = function(seal)
    local count = 0
    for _, c in ipairs(G.playing_cards) do
        if (seal and c.seal == seal) or (not seal and c.seal) then
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

force_pseudorandom_roll = function(forced_seed, roll)
    local original_pseudorandom = pseudorandom
    pseudorandom = function(seed, ...)
        if seed == forced_seed then return roll end
        return original_pseudorandom(seed, ...)
    end
    return function() pseudorandom = original_pseudorandom end
end

force_hat_hair_roll = function(roll)
    return force_pseudorandom_roll('hat_hair', roll)
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

-- Only reaches the shop when Speedwagon Foundation Submarine is held; otherwise use end_round and cash_out
skip_blind_into_shop = function()
    skip_blind_for_tag('tag_double')
    Balatest.wait_for_input(G.STATES.SHOP)
end

-- A big scoring hand would win the round and fire end of round effects before assert runs
keep_blind_unbeaten = function()
    Balatest.q(function() G.GAME.blind.chips = 1e12 end)
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

set_joker_edition = function(index, edition)
    Balatest.q(function() G.jokers.cards[index]:set_edition(edition, true, true) end)
    Balatest.wait()
end

-- Overwrites cards from the bottom of the area up, so a deck's draw order stays deterministic
set_card_bases = function(area, keys)
    for i, key in ipairs(keys) do
        area.cards[i]:set_base(G.P_CARDS[key])
    end
end

set_hand_facing = function(facing)
    Balatest.q(function()
        for _, c in ipairs(G.hand.cards) do
            if c.facing ~= facing then c:flip() end
        end
    end)
end

count_face_down_cards = function(area)
    local count = 0
    for _, c in ipairs(area.cards) do
        if c.facing == 'back' then
            count = count + 1
        end
    end
    return count
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

count_perishable_shop_rolls = function(rolls)
    G.GAME.modifiers.enable_perishables_in_shop = true
    local perishable = 0
    for _ = 1, rolls do
        local card = create_card('Joker', G.shop_jokers, nil, nil, nil, nil, nil, 'perishable_roll')
        if card.ability.perishable then perishable = perishable + 1 end
        card:remove()
    end
    return perishable
end

-- Polpo picks its consumable set from this exact list, so only that call is forced
force_polpo_consumable_set = function(set)
    Balatest.hook(_G, 'pseudorandom_element', function(orig, t, seed, ...)
        if #t == 3 and t[1] == 'Tarot' and t[2] == 'Planet' and t[3] == 'Spectral' then return set end
        return orig(t, seed, ...)
    end)
end

force_scary_monsters_suit = function(suit)
    Balatest.hook(_G, 'pseudorandom_element', function(orig, t, seed, ...)
        if seed == 'jojoker_scary_monsters' then return SMODS.Suits[suit], suit end
        return orig(t, seed, ...)
    end)
end

force_silver_chariot_requiem_rank = function(rank)
    Balatest.hook(_G, 'pseudorandom_element', function(orig, t, seed, ...)
        if seed == 'jojoker_silver_chariot_requiem' then return SMODS.Ranks[rank] end
        return orig(t, seed, ...)
    end)
end

-- align_cards only keeps a card's x position while it is being dragged, so fake the drag until it settles
drag_joker = function(card, x)
    card.states.drag.is = true
    card.T.x = x
    G.jokers:align_cards()
    card.states.drag.is = false
    G.jokers:align_cards()
end

description_key = function(card)
    local key = card.config.center:loc_vars({}, card).key or card.config.center.key
    return (key:gsub('_alt$', ''))
end

pool_offers = function(pool_type, key, rarity)
    for _, v in ipairs(get_current_pool(pool_type, rarity)) do
        if v == key then return true end
    end
    return false
end

count_wired_cards = function(area)
    local count = 0
    for _, c in ipairs(area.cards) do
        if c.ability.jojoker_wired then
            count = count + 1
        end
    end
    return count
end

-- Wired picks at random, so rewrite ranks afterward to tell the wired cards from the rest
set_wired_card_bases = function(wired_keys, unwired_key)
    Balatest.q(function()
        local wired_index = 0
        for _, c in ipairs(G.hand.cards) do
            if c.ability.jojoker_wired then
                wired_index = wired_index + 1
                c:set_base(G.P_CARDS[wired_keys[wired_index]])
            else
                c:set_base(G.P_CARDS[unwired_key])
            end
        end
    end)
end

identical_cards = function(rank, suit, count)
    local cards = {}
    for i = 1, count do cards[i] = { r = rank, s = suit } end
    return cards
end

-- Counts jokers' random tag grants; G.GAME.tags drops immediate tags and Double Tag adds extra copies
count_random_tags_given = function()
    local given = { count = 0 }
    Balatest.hook(_G, 'jojoker_add_random_tag', function(orig, ...)
        given.count = given.count + 1
        return orig(...)
    end)
    return given
end

only_jokers_in_shop = function()
    Balatest.q(function()
        G.GAME.playing_card_rate = 0
        G.GAME.spectral_rate = 0
        for _, v in ipairs(SMODS.ConsumableType.ctype_buffer) do
            G.GAME[v:lower()..'_rate'] = 0
        end
    end)
end

no_jokers_in_shop = function()
    Balatest.q(function() G.GAME.joker_rate = 0 end)
end
