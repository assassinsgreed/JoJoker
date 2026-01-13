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
    if jtype == "User" then
      text_colour = G.C.BLACK
    end
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

remove = function(self, card, context, check_shiny)
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