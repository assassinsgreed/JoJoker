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

get_class = function(card)
  if card.ability then
    if type(card.ability.extra) == "table" and card.ability.extra.jclass then
      return card.ability.extra.jclass
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
  
  -- Joker class, optional (ex. Close Range, Automatic, etc.)
  local jclass = get_class(card)
  if jclass then
    local lower_jclass = string.lower(string.gsub(jclass, " ", "_"))
    jclass = localize('joker_class_'..lower_jclass..'_badge')
    badges[#badges+1] = create_badge(jclass, G.ARGS.LOC_COLOURS[lower_jclass], G.C.WHITE, 1.2 )
  end
end

remove = function(self, card, context, check_menacing_aura)
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

handle_left_side_ataxia_disabling = function(left_side_ataxia_card)
  local disabled = 0
  local my_pos = 999 -- Max out to find cards before Left-Side Ataxia
  for i = 1, #G.jokers.cards do
      local other_joker = G.jokers.cards[i]
      if other_joker ~= left_side_ataxia_card then
        -- Disable / restore joker based on Left-Side-Ataxia's position in the joker lineup,
        -- (restoring ONLY if disabled by Left-Side-Ataxia, to avoid restoring jokers disabled by other effects)
        if i < my_pos then
          -- sendDebugMessage("Disabling joker at position "..i.." because it is before Left-Side Ataxia")
          other_joker.ability.extra.lta_disabled = true
          disabled = disabled + 1
          SMODS.debuff_card(other_joker, true, left_side_ataxia_card)
        else
          if other_joker.ability.extra.lta_disabled then
            -- sendDebugMessage("Restoring joker at position "..i.." because it is after Left-Side Ataxia")
            -- Manually handle restore, because SMODS can't restore the card if the game is reloaded...
            other_joker.ability.extra.lta_disabled = false
            other_joker.ability.debuff_sources[tostring(left_side_ataxia_card)] = false
            SMODS.recalc_debuff(other_joker)
          end
        end
      else
          if other_joker == left_side_ataxia_card then
            -- sendDebugMessage("Found Left-Side Ataxia at position "..i)
            my_pos = i
          end
      end
  end
  return disabled
end

get_random_joker_key = function(seed)
  -- Ban jokers that copy others' effects
  local excluded_keys = {'khnum', 'surface', 'the_fool', 'kars_stopped_thinking', 'stroheim_german_engineering'}
  local jojoker_keys = {}
  local chosen_key

  for k, v in pairs(G.P_CENTERS) do
    if v.jtype and get_part_allowed(v) and (not (type(v.in_pool) == 'function') or v:in_pool())
       and not G.GAME.banned_keys[v.key] and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key)) then

      if v.enhancement_gate then
        if G.playing_cards then
          for kk, vv in pairs(G.playing_cards) do
            if SMODS.has_enhancement(vv, v.enhancement_gate) and not excluded_keys[v.key] then
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
