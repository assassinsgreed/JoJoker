-- Even ranks are 2, 4, 6, 8, 10; odd ranks are Ace (id 14), 3, 5, 7, 9.
-- Face cards are neither, matching the base game's Odd Todd / Even Steven.
card_is_even = function(card)
  local id = card:get_id()
  return id <= 10 and id % 2 == 0
end

card_is_odd = function(card)
  local id = card:get_id()
  return id == 14 or (id <= 10 and id % 2 == 1)
end

remove_playing_card = function(target, card, trigger)
      if target.ability.name == 'Glass Card' then
          target.shattered = true
      else 
          target.destroyed = true
      end 
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true end }))
      G.E_MANAGER:add_event(Event({
          trigger = trigger and trigger or 'after',
          delay = 0.2,
          func = function() 
              if target.ability.name == 'Glass Card' then
                  target:shatter()
              else
                  target:start_dissolve()
              end
          return true end }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = {target}})
      end
      card:juice_up()
end

rank_string_from_id = function(id)
    if id == 14 then return "Ace" end
    if id == 13 then return "King" end
    if id == 12 then return "Queen" end
    if id == 11 then return "Jack" end
    return tostring(id)
end

shorthand_rank_string_from_id = function(id)
    if id == 14 then return "A" end
    if id == 13 then return "K" end
    if id == 12 then return "Q" end
    if id == 11 then return "J" end
    return tostring(id)
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

stabilize_chip_drain = function(card)
  if not card or not card.ability or not card.base or not card.base.nominal or not card.ability.bonus then return end
  card.ability.nominal_drain = card.ability.nominal_drain or 0
  card.ability.nominal_drain = math.min(card.ability.nominal_drain, card.base.nominal - 1)
  card.ability.perma_bonus = card.ability.perma_bonus or 0
  card.ability.perma_bonus = math.max(card.ability.perma_bonus, -card.ability.bonus)
end
