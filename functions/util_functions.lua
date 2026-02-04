card_is_even = function(card)
  return card:get_id() % 2 == 0
end

card_is_odd = function(card)
  return card:get_id() % 2 == 1
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