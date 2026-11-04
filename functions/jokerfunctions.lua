get_part_allowed = function(card)
    local part_allowed = false
    if card.part then
        local part = card.part
        if part == "phantom_blood" and jojoker_config.phantom_blood then part_allowed = true end
        if part == "battle_tendency" and jojoker_config.battle_tendency then part_allowed = true end
        if part == "stardust_crusaders" and jojoker_config.stardust_crusaders then part_allowed = true end
        if part == "diamond_is_unbreakable" and jojoker_config.diamond_is_unbreakable then part_allowed = true end
        if part == "golden_wind" and jojoker_config.golden_wind then part_allowed = true end
        if part == "stone_ocean" and jojoker_config.stone_ocean then part_allowed = true end
        if part == "steel_ball_run" and jojoker_config.steel_ball_run then part_allowed = true end
        if part == "jojolion" and jojoker_config.jojolion then part_allowed = true end
        if part == "the_jojolands" and jojoker_config.the_jojolands then part_allowed = true end
    else
        part_allowed = true
    end
    return part_allowed
end

joker_load_individual_sprite = function(self, card, initial, delay_sprites)
    if initial and card and card.ability and card.ability.extra and not card.ability.extra.loaded_pos then
        card.ability.extra.loaded_pos = card.config.center.pos
    end
end

get_type = function(card)
  if card.ability then
    if type(card.ability.extra) == "table" and card.ability.extra.jtype then
      return card.ability.extra.jtype
    end
  end
  return nil
end

jojoker_set_joker_badges = function(self, card, badges)
  -- Joker type (ex. stand, user, effect, etc.)
  local jtype = get_type(card)
  if jtype then
    local lower_jtype = string.lower(jtype)
    local text_colour = G.C.WHITE
    jtype = localize('joker_type_'..lower_jtype..'_badge')
    badges[#badges+1] = create_badge(jtype, G.ARGS.LOC_COLOURS[lower_jtype], text_colour, 1.2 )
  end
  
  if card.ability and card.ability.jojoker_notorious_xmult then
    local notorious = localize{type = 'variable', key = 'jojoker_notorious_badge', vars = {card.ability.jojoker_notorious_xmult}}
    badges[#badges+1] = create_badge(notorious, G.C.XMULT, G.C.WHITE, 1.2 )
  end

  if card.ability and card.ability.jojoker_purple_haze_chips then
    local infected = localize{type = 'variable', key = 'jojoker_purple_haze_badge', vars = {card.ability.jojoker_purple_haze_chips, card.ability.jojoker_purple_haze_mult}}
    badges[#badges+1] = create_badge(infected, G.C.PURPLE, G.C.WHITE, 1.2 )
  end
end

-- Chained as the deepest extra so the bonus scores after the joker's own effect
jojoker_append_joker_main_bonus = function(context, ret, bonus)
  if not (context and context.joker_main and not context.blueprint) then return ret end
  if ret ~= nil and type(ret) ~= 'table' then return ret end
  if not ret then return bonus end

  local last = ret
  while last.extra do last = last.extra end
  last.extra = bonus
  return ret
end

jojoker_add_notorious_xmult = function(card, context, ret)
  if not (card and card.ability and card.ability.jojoker_notorious_xmult) then return ret end
  return jojoker_append_joker_main_bonus(context, ret, {
    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.jojoker_notorious_xmult}},
    colour = G.C.XMULT,
    Xmult_mod = card.ability.jojoker_notorious_xmult
  })
end

-- Grows before scoring so the first activation already counts; retriggers and copies only score it
jojoker_add_purple_haze_bonus = function(card, context, ret)
  if not (card and card.ability and card.ability.jojoker_purple_haze_chips) then return ret end
  if not (context and context.joker_main and not context.blueprint) then return ret end
  if not context.retrigger_joker then
    local growth = G.P_CENTERS.j_jojoker_purple_haze.config.extra
    card.ability.jojoker_purple_haze_chips = card.ability.jojoker_purple_haze_chips + growth.chips_mod
    card.ability.jojoker_purple_haze_mult = card.ability.jojoker_purple_haze_mult + growth.mult_mod
    jojoker.debug("Purple Haze: "..card.ability.name.." grew to +"..card.ability.jojoker_purple_haze_chips.." chips and +"..card.ability.jojoker_purple_haze_mult.." mult")
  end
  return jojoker_append_joker_main_bonus(context, ret, {
    chips = card.ability.jojoker_purple_haze_chips,
    mult = card.ability.jojoker_purple_haze_mult
  })
end

remove = function(self, card, context)
  card.getting_sliced = true
  local flags = SMODS.calculate_context({ joker_type_destroyed = true, card = card })
  if flags.no_destroy then
    card.getting_sliced = nil
    return
  end
  play_sound('tarot1')
  card.T.r = -0.2
  card.states.drag.is = true
  card.children.center.pinch.x = true
  G.E_MANAGER:add_event(Event({
      trigger = 'after', delay = 0.3, blockable = false,
      func = function()
          G.jokers:remove_card(card)
          card:remove()
          card = nil
          return true
      end
  }))
  card.gone = true
  return true
end

find_joker_pos = function(card)
  local card_index = nil
  for i, joker in ipairs(G.jokers.cards) do
      if joker == card then
          card_index = i
          break
      end
  end
  return card_index
end

pick_random_hand_type = function()
    local hand_options = {}
    local hand_names = {}
    for k,v in pairs(G.GAME.hands) do
      if v.visible then
          local hand = v
          hand.handname = k
          table.insert(hand_options, hand)
          table.insert(hand_names, hand.handname)
      end
  end

  if #hand_options > 0 then
      return hand_options[math.random(#hand_options)]
  end
  return nil
end

joker_total_chips = function(card)
  local total_chips = (card.ability.bonus) + (card.ability.perma_bonus or 0)
  if card.ability.effect ~= 'Stone Card' and not card.config.center.replace_base_card then
    total_chips = total_chips + (card.base.nominal)
  end
  if card.edition then
    total_chips = total_chips + (card.edition.chips or 0)
  end
  return total_chips
end

ease_joker_dollars = function(card, seed, amt, calc_only)
  local earned = amt
  if card.ability.extra and type(card.ability.extra) == "table" then
    if card.ability.money_frac then
      if card.ability.money_frac > pseudorandom(pseudoseed(seed)) then
        earned = earned + 1
      end
    end
    if card.ability.money1_frac then
      if card.ability.money1_frac > pseudorandom(pseudoseed(seed)) then
        earned = earned + 1
      end
    end
    if card.ability.money2_frac then
      if card.ability.money2_frac > pseudorandom(pseudoseed(seed)) then
        earned = earned + 1
      end
    end
  end
  if not calc_only then ease_dollars(earned) end
  return earned
end

-- Tracks purchases in the shop (not rerolls) across the entire run (for Harvest's effect)
jojoker_track_shop_spending = function(context)
  if not (context.buying_card or context.open_booster) then return end
  local cost = context.card and context.card.cost or 0
  if cost <= 0 then return end
  G.GAME.jojoker_shop_dollars_spent = (G.GAME.jojoker_shop_dollars_spent or 0) + cost
  jojoker.debug("Shop spending: $"..cost.." spent, $"..G.GAME.jojoker_shop_dollars_spent.." total this run")
end

get_harvest_payout = function(card)
  local spent = G.GAME.jojoker_shop_dollars_spent or 0
  return math.floor(spent / card.ability.extra.spend_per_payout) * card.ability.extra.money_mod
end

-- Tracks Black Holes used across the entire run (for Cream's effect)
jojoker_track_black_holes_used = function(context)
  if not (context.using_consumeable and context.consumeable and context.consumeable.config.center.key == 'c_black_hole') then return end
  G.GAME.jojoker_black_holes_used = (G.GAME.jojoker_black_holes_used or 0) + 1
  jojoker.debug("Black Hole used: "..G.GAME.jojoker_black_holes_used.." total this run")
end

get_cream_mult = function(card)
  local highest_level = 1
  for _, hand in pairs(G.GAME.hands) do
    if hand.level > highest_level then highest_level = hand.level end
  end
  return highest_level * card.ability.extra.mult_per_level + (G.GAME.jojoker_black_holes_used or 0) * card.ability.extra.mult_per_black_hole
end

get_goo_goo_dolls_mult = function(card)
  local missing = G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0
  return math.max(0, missing) * card.ability.extra.mult
end

get_bad_company_mult = function(card)
  local extra = G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0
  return math.max(0, extra) * card.ability.extra.mult
end

jojoker_track_bosses_beaten = function(context)
  if not (context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss) then return end
  if context.individual or context.repetition then return end
  G.GAME.jojoker_bosses_beaten = (G.GAME.jojoker_bosses_beaten or 0) + 1
  jojoker.debug("Boss beaten: "..G.GAME.jojoker_bosses_beaten.." total this run")
end

-- Hieroglyph, Petroglyph, and Killer Queen all send the ante backward through ease_ante
jojoker_ante_reversed = function(mod)
  if G.STAGE ~= G.STAGES.RUN or not mod or mod >= 0 then return end
  jojoker.debug("Ante reversed by "..-mod)
  SMODS.calculate_context({ jojoker_ante_reversed = true, amount = -mod })
end

transform_joker = function(card, target_key)
    local custom_values_to_keep = {}
    local has_custom_values_to_keep = nil
    local new_card = G.P_CENTERS[target_key]
    local trigger_add = nil
    if card.config.center == new_card then return end
    
    -- If it's perishable, reset it's perish counter
    if card.ability.perishable then
        if card.ability.perish_tally == 0 then trigger_add = true end
        card.ability.perish_tally = G.GAME.perishable_rounds
        card.debuff = false
    end

    -- Collect config values to retain
    if card.config.center.custom_values_to_keep then
      for k, v in pairs(card.config.center.custom_values_to_keep) do
        custom_values_to_keep[v] = card.ability.extra[v]
      end
      has_custom_values_to_keep = true
    end

    -- Perform transformation
    card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas or "Joker"], new_card.pos)
    card.children.center.states.hover = card.states.hover
    card.children.center.states.click = card.states.click
    card.children.center.states.drag = card.states.drag
    card.children.center.states.collide.can = false
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_card, true)
    card:set_cost()

    -- Restore custom values to keep
    if has_custom_values_to_keep then
      for k, v in pairs(custom_values_to_keep) do
        card.ability.extra[k] = v
      end
    end

    if new_card.soul_pos then
        card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas or "Joker"], new_card.soul_pos)
        card.children.floating_sprite.role.draw_major = card
        card.children.floating_sprite.states.hover.can = false
        card.children.floating_sprite.states.click.can = false
    elseif card.children.floating_sprite then
        card.children.floating_sprite:remove()
        card.children.floating_sprite = nil
    end

    if not card.edition then
        card:juice_up()
        play_sound('generic1')
    else
        card:juice_up(1, 0.5)
        if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
        if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
        if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
        if card.edition.negative then play_sound('negative', 1.5, 0.4) end
    end
    
    if trigger_add then
        card:add_to_deck()
    end
end

get_joker_count = function (name)
  if G.jokers and #G.jokers.cards > 0 then
      local jokerCount = 0
      for _, joker in ipairs(G.jokers.cards) do
          if joker.config.center.name == name then
              jokerCount = jokerCount + 1
          end
      end
      return jokerCount
  end
  return 0
end

get_joker_count_by_type = function (jtype)
  if G.jokers and #G.jokers.cards > 0 then
      local jokerCount = 0
      for _, joker in ipairs(G.jokers.cards) do
          if joker.ability and joker.ability.extra and joker.ability.extra.jtype == jtype then
              jokerCount = jokerCount + 1
          end
      end
      return jokerCount
  end
  return 0
end

-- Non-JoJoker jokers may use a non-table ability.extra (often a number),
-- so store the flag on ability directly for those. Both spots are saved/reloaded.
set_lsa_disabled = function(joker, disabled)
  if type(joker.ability.extra) == 'table' then
    joker.ability.extra.lsa_disabled = disabled
  else
    joker.ability.lsa_disabled = disabled
  end
end

get_lsa_disabled = function(joker)
  if type(joker.ability.extra) == 'table' then
    return joker.ability.extra.lsa_disabled
  end
  return joker.ability.lsa_disabled
end

handle_left_side_ataxia_disabling = function(left_side_ataxia_card)
  local disabled = 0
  local my_pos = 999 -- Max out to find cards before Left-Side Ataxia
  for i = 1, #G.jokers.cards do
      local other_joker = G.jokers.cards[i]
      if other_joker ~= left_side_ataxia_card then
        -- Disable / restore joker based on Left-Side-Ataxia's position in the joker lineup,
        -- (restoring ONLY if disabled by Left-Side-Ataxia, to avoid restoring jokers disabled by other effects)
        if i < my_pos then
          -- jojoker.debug("Disabling joker at position "..i.." because it is before Left-Side Ataxia")
          set_lsa_disabled(other_joker, true)
          disabled = disabled + 1
          SMODS.debuff_card(other_joker, true, left_side_ataxia_card)
        else
          if get_lsa_disabled(other_joker) then
            -- jojoker.debug("Restoring joker at position "..i.." because it is after Left-Side Ataxia")
            -- Manually handle restore, because SMODS can't restore the card if the game is reloaded...
            set_lsa_disabled(other_joker, false)
            other_joker.ability.debuff_sources[tostring(left_side_ataxia_card)] = false
            SMODS.recalc_debuff(other_joker)
          end
        end
      else
          if other_joker == left_side_ataxia_card then
            -- jojoker.debug("Found Left-Side Ataxia at position "..i)
            my_pos = i
          end
      end
  end
  return disabled
end

get_random_joker_key = function(seed)
  -- Ban jokers that copy others' effects
  local excluded_keys = {
    ['j_jojoker_khnum'] = true,
    ['j_jojoker_surface'] = true,
    ['j_jojoker_the_fool'] = true,
    ['j_jojoker_kars_stopped_thinking'] = true,
    ['j_jojoker_stroheim_german_engineering'] = true,
  }
  local jojoker_keys = {}
  local chosen_key

  for k, v in pairs(G.P_CENTERS) do
    if v.jtype and not excluded_keys[v.key] and get_part_allowed(v) and (not (type(v.in_pool) == 'function') or v:in_pool())
       and not G.GAME.banned_keys[v.key] and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key)) then

      if v.enhancement_gate then
        if G.playing_cards then
          for kk, vv in pairs(G.playing_cards) do
            if SMODS.has_enhancement(vv, v.enhancement_gate) then
              table.insert(jojoker_keys, v.key)
              break
            end
          end
        end
      else
        table.insert(jojoker_keys, v.key)
      end
    end
  end

  if #jojoker_keys > 0 then
    chosen_key = pseudorandom_element(jojoker_keys, pseudoseed(seed))
  else
    chosen_key = "j_jojoker_jonathan_joestar"
  end

  return chosen_key
end

get_most_played_hand_info = function()
  local highest_played = 0
  local highest_hands = {}
  for handname, values in pairs(G.GAME.hands) do
    if SMODS.is_poker_hand_visible(handname) then
      if values.played > highest_played then
        highest_hands = {}
        highest_hands[#highest_hands + 1] = handname
        highest_played = values.played
      elseif values.played == highest_played then
        highest_hands[#highest_hands + 1] = handname
      end
    end
  end

  return { count = highest_played, name = highest_hands[1] or "High Card" }
end

get_most_used_tarot_info = function()
  local highest_key, highest_count, highest_order = nil, 0, nil
  for key, usage in pairs(G.GAME.consumeable_usage or {}) do
    if usage.set == 'Tarot' and G.P_CENTERS[key] then
      -- Ties fall to the lower collection order so the reported tarot cannot flicker between two equally used ones
      local order = usage.order or 0
      if usage.count > highest_count or (highest_order and usage.count == highest_count and order < highest_order) then
        highest_key, highest_count, highest_order = key, usage.count, order
      end
    end
  end

  return {
    key = highest_key,
    count = highest_count,
    name = highest_key and localize{type = 'name_text', key = highest_key, set = 'Tarot'} or localize('none_used')
  }
end

-- Rerolled cards are new, so the couponed flag naturally does not carry over to them
jojoker_free_random_shop_item = function(seed)
  local candidates = {}
  for _, area in ipairs({ G.shop_jokers, G.shop_booster }) do
    for _, item in ipairs(area and area.cards or {}) do
      if not item.ability.couponed then candidates[#candidates + 1] = item end
    end
  end
  if #candidates == 0 then return nil end

  local item = pseudorandom_element(candidates, pseudoseed(seed))
  item.ability.couponed = true
  item:set_cost()
  return item
end

-- Jokers that duplicate by creating a card from a key never reach copy_card, so they call this directly
jojoker_card_duplicated = function(card)
  if G.STAGE ~= G.STAGES.RUN then return end
  jojoker.debug("Card duplicated: "..tostring(card and card.config.center.key))
  SMODS.calculate_context({ jojoker_card_duplicated = true, card = card })
end

-- Booster contents are built from spawn tables, so Enya guarantees its tarot by replacing the first one
jojoker_force_pack_card = function(booster_card, i, spawned)
  local prerolled = thoth_take_prerolled_card(booster_card, i)
  if prerolled then
    if type((spawned or {}).is) == 'function' and spawned:is(Card) then spawned:remove() end
    return prerolled
  end

  if i ~= 1 or G.STAGE ~= G.STAGES.RUN then return nil end
  if not booster_card or not booster_card.config or booster_card.config.center.kind ~= 'Arcana' then return nil end
  if #SMODS.find_card('j_jojoker_enya') == 0 then return nil end

  local tarot = get_most_used_tarot_info()
  if not tarot.key then return nil end

  jojoker.debug("Enya: Forcing "..tarot.name.." into the opened Arcana Pack")
  return { set = 'Tarot', area = G.pack_cards, skip_materialize = true, soulable = true, key = tarot.key, key_append = 'ar1' }
end

-- Matches the pack size Card:open uses, including the extra picks it adds to ability.extra
thoth_booster_size = function(booster)
  return math.max(1, booster.ability.extra + (G.GAME.extra_booster_picks or 0) + (G.GAME.modifiers.booster_size_mod or 0))
end

-- Contents are saved on the booster's ability so the preview survives a reload and opening gives the same cards
thoth_preroll_booster = function(booster)
  if not booster or booster.ability.thoth_contents or not booster.config.center.create_card then return end

  local size = thoth_booster_size(booster)
  local prev_pack_cards, prev_opened_booster = G.pack_cards, SMODS.OPENED_BOOSTER
  -- Spawn tables and sticker/edition polls compare against G.pack_cards, so stand in for the opened pack
  G.pack_cards = CardArea(0, 0, G.CARD_W, G.CARD_H, { card_limit = size, type = 'consumeable' })
  SMODS.OPENED_BOOSTER = booster

  local cards = {}
  for i = 1, size do
    local spawn = booster.config.center:create_card(booster, i)
    spawn = jojoker_force_pack_card(booster, i, spawn) or spawn
    cards[i] = (type((spawn or {}).is) == 'function' and spawn:is(Card)) and spawn or SMODS.create_card(spawn)
  end

  booster.ability.thoth_contents = {}
  for i, card in ipairs(cards) do
    booster.ability.thoth_contents[i] = copy_table(card:save())
    card:remove()
  end

  G.pack_cards:remove()
  G.pack_cards, SMODS.OPENED_BOOSTER = prev_pack_cards, prev_opened_booster
  jojoker.debug("Thoth: Prerolled "..size.." cards for "..booster.config.center.key)
end

thoth_preroll_shop_boosters = function()
  for _, booster in ipairs(G.shop_booster and G.shop_booster.cards or {}) do
    thoth_preroll_booster(booster)
  end
end

thoth_load_card = function(saved)
  loading = true
  local card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CENTERS.j_joker, G.P_CENTERS.c_base)
  loading = nil
  card:load(copy_table(saved))
  return card
end

thoth_take_prerolled_card = function(booster, i)
  local contents = booster and booster.ability and booster.ability.thoth_contents
  if not contents or not contents[i] then return nil end
  jojoker.debug("Thoth: Using prerolled card "..i.." for "..booster.config.center.key)
  return thoth_load_card(contents[i])
end

thoth_show_booster_preview = function(booster)
  if booster.area ~= G.shop_booster or not next(SMODS.find_card('j_jojoker_thoth')) then return end
  thoth_preroll_booster(booster)
  local contents = booster.ability.thoth_contents
  if not contents then return end

  thoth_hide_booster_preview()
  local scale = 0.7
  local preview = CardArea(0, 0, math.min(#contents, 5) * G.CARD_W * scale, G.CARD_H * scale, { card_limit = #contents, type = 'title' })
  preview.T.x = booster.T.x + booster.T.w / 2 - preview.T.w / 2
  preview.T.y = booster.T.y - preview.T.h - 0.2
  preview:hard_set_VT()
  preview.thoth_booster = booster

  for _, saved in ipairs(contents) do
    local card = thoth_load_card(saved)
    local w, h = card.T.w * scale, card.T.h * scale
    card:hard_set_T(booster.T.x + booster.T.w / 2 - w / 2, booster.T.y + booster.T.h / 2 - h / 2, w, h)
    card.states.drag.can = false
    card.states.hover.can = false
    preview:emplace(card)
  end
  G.thoth_booster_preview = preview
end

thoth_hide_booster_preview = function(booster)
  local preview = G.thoth_booster_preview
  if not preview or (booster and preview.thoth_booster ~= booster) then return end
  preview:remove()
  G.thoth_booster_preview = nil
end

-- Must fire before the destroyed joker is marked getting_sliced, which excludes it from calculation
jojoker_joker_destroyed_by_joker = function(destroyed, destroyer)
  if G.STAGE ~= G.STAGES.RUN or not destroyed or not destroyer or destroyed == destroyer then return end
  jojoker.debug("Joker destroyed: "..destroyed.config.center.key.." by "..destroyer.config.center.key)
  SMODS.calculate_context({ jojoker_joker_destroyed_by_joker = true, card = destroyed, destroyer = destroyer })
end

jojoker_handle_card_copy = function(other, new_card, card_scale)
  -- Previews pass a card_scale, effects that overwrite a card (ex. Death) pass new_card, and
  -- redeeming a voucher copies it into G.vouchers -- none of those are duplications
  if new_card or card_scale or not other then return end
  if other.ability and other.ability.set == 'Voucher' then return end
  jojoker_card_duplicated(other)
end

-- Poker hand detection and every rank check read get_id, so Tequila Joseph rewrites the id there
jojoker_rank_id = function(card)
  local rank = SMODS.Ranks[card.base.value]
  if rank and rank.face and next(SMODS.find_card('j_jojoker_tequila_joseph')) then
    return SMODS.Ranks['Queen'].id
  end
  return card.base.id
end

get_lowest_scored_rank_id = function(scoring_hand)
  local lowest = nil
  for _, scored_card in ipairs(scoring_hand or {}) do
    if not SMODS.has_no_rank(scored_card) and (not lowest or scored_card:get_id() < lowest) then
      lowest = scored_card:get_id()
    end
  end
  return lowest
end

has_scoring_face_and_stone = function(scoring_hand)
  local has_face, has_stone = false, false
  for _, scored_card in ipairs(scoring_hand or {}) do
    has_face = has_face or scored_card:is_face()
    has_stone = has_stone or SMODS.has_enhancement(scored_card, 'm_stone')
  end
  return has_face and has_stone
end

-- Counts every card drawn to hand while Hayato is held; true for every second one
hayato_flips_draw = function()
  local hayato = SMODS.find_card('j_jojoker_hayato')[1]
  if not hayato then return false end
  hayato.ability.extra.draws = hayato.ability.extra.draws + 1
  return hayato.ability.extra.draws % 2 == 0
end

-- Any face down card outside the poker hand voids the bonus, including ones only scored by Splash effects
get_hayato_xmult = function(card, hand_cards, played_cards)
  if #hand_cards < 2 then return 1 end
  local in_hand = {}
  for _, hand_card in ipairs(hand_cards) do in_hand[hand_card] = true end
  local face_down = 0
  for _, played_card in ipairs(played_cards) do
    if played_card.facing == 'back' or played_card.ability.jojoker_played_face_down then
      if not in_hand[played_card] then return 1 end
      face_down = face_down + 1
    end
  end
  return 1 + card.ability.extra.xmult_mod * face_down
end

jojoker_pull_rank_from_deck = function(rank_id)
  local matches = {}
  for _, deck_card in ipairs(G.deck.cards) do
    if not SMODS.has_no_rank(deck_card) and deck_card:get_id() == rank_id then
      matches[#matches + 1] = deck_card
    end
  end
  for _, match in ipairs(matches) do
    draw_card(G.deck, G.hand, nil, 'up', true, match)
  end

  -- Pulled cards are not a hand draw, so keep them out of the next hand_drawn context
  G.E_MANAGER:add_event(Event({
    func = function()
      for i = #(SMODS.drawn_cards or {}), 1, -1 do
        for _, match in ipairs(matches) do
          if SMODS.drawn_cards[i] == match then
            table.remove(SMODS.drawn_cards, i)
            break
          end
        end
      end
      return true
    end
  }))
  return #matches
end

get_loccobarocco_chips = function(card, scoring_hand)
  local chips = 0
  for _, scored_card in ipairs(scoring_hand or {}) do
    if scored_card.debuff then
      chips = chips + scored_card:get_chip_bonus() * card.ability.extra.chip_multiplier
    end
  end
  return chips
end

-- Pairs are matched by id because they persist after a reload
get_d4c_partner = function(card)
  if not G.jokers then return nil end
  for _, joker in ipairs(G.jokers.cards) do
    if joker ~= card and joker.config.center.key == 'j_jojoker_d4c' and not joker.removed
       and joker.ability.extra.pair_id == card.ability.extra.pair_id
       and not joker.ability.extra.is_copy ~= not card.ability.extra.is_copy then
      return joker
    end
  end
  return nil
end

-- Other D4C pairs' copies are skipped so D4C cannot reroll them into free eternal negative legendaries
get_d4c_caught_jokers = function(card)
  local partner = get_d4c_partner(card)
  if not partner then return {} end
  local first, last = find_joker_pos(card), find_joker_pos(partner)
  if not first or not last then return {} end
  if first > last then first, last = last, first end

  local caught = {}
  for i = first + 1, last - 1 do
    local joker = G.jokers.cards[i]
    if not (joker.config.center.key == 'j_jojoker_d4c' and joker.ability.extra.is_copy) then
      caught[#caught + 1] = joker
    end
  end
  return caught
end

jojoker_spawn_d4c_copy = function(card)
  G.GAME.jojoker_d4c_pairs = (G.GAME.jojoker_d4c_pairs or 0) + 1
  card.ability.extra.pair_id = G.GAME.jojoker_d4c_pairs

  local copy = SMODS.create_card({ key = 'j_jojoker_d4c', area = G.jokers, edition = 'e_negative', no_edition = true })
  copy.ability.extra.is_copy = true
  copy.ability.extra.pair_id = card.ability.extra.pair_id
  -- D4C is not eternal compatible like every legendary, so the copy bypasses the check
  copy:add_sticker('eternal', true)
  copy:add_to_deck()
  G.jokers:emplace(copy)
  jojoker.debug("D4C: Spawned eternal negative copy for pair "..card.ability.extra.pair_id)
  return copy
end

-- The replacement's own eternal/perishable compatibility decides which stickers remain
jojoker_replace_joker_same_rarity = function(old)
  local rarity = old.config.center.rarity
  local new = SMODS.create_card({
    set = 'Joker',
    area = G.jokers,
    rarity = ({ 'Common', 'Uncommon', 'Rare', 'Legendary' })[rarity] or rarity,
    edition = old.edition and old.edition.key,
    no_edition = true,
    key_append = 'd4c',
  })
  if old.ability.eternal then new:set_eternal(true) end
  if old.ability.perishable then
    new:set_perishable(true)
    if new.ability.perishable then
      new.ability.perish_tally = old.ability.perish_tally
      SMODS.recalc_debuff(new)
    end
  end
  if old.ability.rental then new:set_rental(true) end

  new:add_to_deck()
  G.jokers:emplace(new)
  table.remove(G.jokers.cards, find_joker_pos(new))
  table.insert(G.jokers.cards, find_joker_pos(old), new)
  jojoker.debug("D4C: Replaced "..old.config.center.key.." with "..new.config.center.key)
  old:start_dissolve()
  return new
end

-- Keyed to G.GAME rather than stored in it, so a save mid-skip or a new run cannot leave it stuck
jojoker_open_shop_after_skip = function()
  if G.jojoker_skip_shop_game == G.GAME then return end
  G.jojoker_skip_shop_game = G.GAME

  -- Non-blocking so booster packs opened by the skip tag can finish first
  G.E_MANAGER:add_event(Event({
    blocking = false,
    func = function()
      if G.STATE ~= G.STATES.BLIND_SELECT or not G.blind_select or G.GAME.PACK_INTERRUPT then return false end
      for lock, locked in pairs(G.CONTROLLER.locks) do
        if locked and lock ~= 'skip_blind' then return false end
      end

      jojoker.debug("Speedwagon Foundation Submarine: Opening the shop after skipping a blind.")
      G.jojoker_skip_shop_game = nil
      G.blind_select:remove()
      G.blind_prompt_box:remove()
      G.blind_select = nil

      G.GAME.current_round.reroll_cost_increase = 0
      G.GAME.current_round.used_packs = {}
      G.GAME.current_round.free_rerolls = G.GAME.round_resets.free_rerolls
      calculate_reroll_cost(true)
      G.GAME.shop_free = nil
      G.GAME.shop_d6ed = nil

      G.STATE = G.STATES.SHOP
      G.STATE_COMPLETE = false
      return true
    end
  }))
end

jojoker_speed_king_target = function(speed_king)
  local target_id = speed_king.ability.extra.target_id
  if not target_id or not G.jokers then return nil end
  for _, joker in ipairs(G.jokers.cards) do
    if joker.sort_id == target_id and not joker.getting_sliced then return joker end
  end
end

jojoker_is_heated_by_speed_king = function(joker)
  for _, speed_king in ipairs(SMODS.find_card('j_jojoker_speed_king', true)) do
    if speed_king.ability.extra.target_id == joker.sort_id then return true end
  end
  return false
end

jojoker_joker_right_of = function(joker)
  for i, other in ipairs(G.jokers.cards) do
    if other == joker then return G.jokers.cards[i + 1] end
  end
end

-- Runs from the mod-level calculate so a Speed King debuffed by an Eternal neighbour still checks again each blind
jojoker_lock_speed_king_targets = function(context)
  if not context.setting_blind then return end
  for _, speed_king in ipairs(SMODS.find_card('j_jojoker_speed_king', true)) do
    speed_king.ability.extra.unlocked = nil
    local right = jojoker_joker_right_of(speed_king)
    if not jojoker_speed_king_target(speed_king) and right and not right.ability.eternal
      and not right.getting_sliced and not jojoker_is_heated_by_speed_king(right) then
      speed_king.ability.extra.target_id = right.sort_id
      speed_king.ability.extra.heat = 0
      jojoker.debug("Speed King: Locking onto "..right.ability.name)
    end
  end
end

-- Speed King is debuffed when it has nothing to retrigger: its locked joker is gone until the next blind,
-- or an Eternal joker (which can't burn out) waits on its right side
jojoker_update_speed_king = function(speed_king)
  local extra = speed_king.ability.extra
  local blocked_by_eternal = false
  if not jojoker_speed_king_target(speed_king) then
    if extra.target_id then
      extra.unlocked = true
      jojoker.debug("Speed King: Locked joker is gone, debuffed until the next blind")
    end
    extra.target_id = nil
    extra.heat = 0
    local right = jojoker_joker_right_of(speed_king)
    blocked_by_eternal = right and right.ability.eternal and true or false
  end
  extra.blocked_by_eternal = blocked_by_eternal
  local should_debuff = blocked_by_eternal or extra.unlocked or false
  local debuffed = speed_king.ability.debuff_sources and speed_king.ability.debuff_sources.jojoker_speed_king or false
  if debuffed ~= should_debuff then
    SMODS.debuff_card(speed_king, should_debuff, 'jojoker_speed_king')
  end
end

-- Runs after the joker area sorts by position, so a dragged Speed King pulls its heated joker along and the heated joker snaps back
jojoker_keep_speed_king_targets_adjacent = function(area)
  if area ~= G.jokers then return end
  for _, speed_king in ipairs(SMODS.find_card('j_jojoker_speed_king', true)) do
    local target = jojoker_speed_king_target(speed_king)
    if target then
      for i, joker in ipairs(area.cards) do
        if joker == speed_king then
          if area.cards[i + 1] ~= target then
            for j = #area.cards, 1, -1 do
              if area.cards[j] == target then table.remove(area.cards, j) end
            end
            for k, other in ipairs(area.cards) do
              if other == speed_king then table.insert(area.cards, k + 1, target) break end
            end
          end
          break
        end
      end
    end
  end
end

is_four_of_a_kind_of_fours = function(poker_hands)
  local group = poker_hands["Four of a Kind"] and poker_hands["Four of a Kind"][1]
  return group ~= nil and group[1]:get_id() == 4
end

-- Remove debuff state on Mista after round ends
jojoker_recover_mista = function(context)
  if not (context.end_of_round and context.main_eval) or context.individual or context.repetition then return end
  for _, mista in ipairs(SMODS.find_card('j_jojoker_mista', true)) do
    if mista.ability.debuff_sources and mista.ability.debuff_sources.jojoker_mista then
      jojoker.debug("Mista: Round over, no longer debuffed")
      SMODS.debuff_card(mista, false, 'jojoker_mista')
    end
  end
end

avdol_create_tarot = function()
  if #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit then return false end
  G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
  G.E_MANAGER:add_event(Event({
    func = function()
      SMODS.add_card({ set = 'Tarot', key_append = 'avdol' })
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
      return true
    end
  }))
  return true
end
