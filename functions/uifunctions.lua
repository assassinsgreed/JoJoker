-- Filters out all non-Jojoker cards based on config and optionally filters down collection pool
SMODS.collection_pool = function(_base_pool)
  local pool = {}
  if type(_base_pool) ~= 'table' then return pool end
  local is_array = _base_pool[1]
  local ipairs = is_array and ipairs or pairs
  local order_index = {}
  local order_counter = 0
  local function add_order(key)
    order_counter = order_counter + 1
    order_index[key] = order_counter
  end
  for _, entry in ipairs(jojoker.joker_order or {}) do
    if type(entry) == "table" then
      for _, key in ipairs(entry) do add_order(key) end
    else
      add_order(entry)
    end
  end
  for _, v in ipairs(_base_pool) do
    if (not G.ACTIVE_MOD_UI or v.mod == G.ACTIVE_MOD_UI) and not v.no_collection then
      local empty_vanilla = v.set == 'Joker' and not v.part and jojoker_config.jojoker_only_collection
      if not empty_vanilla then pool[#pool+1] = v end
    end
  end

  -- Order jokers by jojoker.joker_order
  if is_array then
    table.sort(pool, function(a, b)
      local a_idx = order_index[a.name] or math.huge
      local b_idx = order_index[b.name] or math.huge
      if a_idx ~= b_idx then return a_idx < b_idx end

      if a.order ~= nil and b.order ~= nil and a.order ~= b.order then
        return a.order < b.order
      end

      return (a.key or a.name or '') < (b.key or b.name or '')
    end)
  elseif not is_array then
    table.sort(pool, function(a,b) return a.order < b.order end)
  end
  return pool
end

-- Add Scan support (Viewing top x cards of deck)
create_scan_cardarea = function()
   local config = { card_limit = 0, type = 'scan' }
   config.major = G.deck
   local scan_view = CardArea(0, 0, 2 * G.CARD_W, 0.5 * G.CARD_H, config)
   scan_view.T.x = G.TILE_W - G.deck.T.w / 2 - scan_view.T.w / 2 - 0.4
   scan_view.T.y = G.TILE_H - G.deck.T.h - scan_view.T.h
   scan_view:hard_set_VT()

   G.GAME.scan_amount = G.GAME.scan_amount or 0
   return scan_view
end

cards_dont_match = function(card1, card2)
   if type(card1) ~= type(card2) then return true end
   if card1.config.center ~= card2.config.center then return true end
   if card1.config.card_key ~= card2.config.card_key then return true end
   if card1.base.name ~= card2.base.name then return true end
   if card1.base.suit ~= card2.base.suit then return true end
   if card1.base.value ~= card2.base.value then return true end
   if type(card1.edition) ~= type(card2.edition) then return true end
   if card1.edition and card1.edition.type ~= card2.edition.type then return true end
   if card1.seal ~= card2.seal then return true end
   if card1.debuff ~= card2.debuff then return true end
   if card1.pinned ~= card2.pinned then return true end
   return false
end

hide_scan_cardarea = function()
   G.scan_view.states.visible = false
   local to_kill = #G.scan_view.cards
   for i = to_kill, 1, -1 do
      G.scan_view.cards[i]:remove()
   end
end

update_scan_cardarea = function(scan_view)
   if not scan_view.states.visible then
      local to_kill = #scan_view.cards
      for i = to_kill, 1, -1 do
         scan_view.cards[i]:remove()
      end
     scan_view.states.visible = true
   end
   if scan_view.children.area_uibox then
      scan_view.children.area_uibox.states.visible = false
   end
   if scan_view.adjusting_cards then return end
   scan_view.adjusting_cards = true

   local deck = {}
   for i = 1, G.GAME.scan_amount do
      if #G.deck.cards + 1 <= i then break end
      deck[i] = G.deck.cards[#G.deck.cards + 1 - i]
   end
   -- blank card that will cause the removal of any extra cards
   deck[G.GAME.scan_amount + 1] = true

   local i = 1
   for k, card in pairs(deck) do
      while i <= #scan_view.cards and cards_dont_match(card,scan_view.cards[i]) do
         scan_view.cards[i]:start_dissolve({G.C.PURPLE})
         i = i + 1
      end
      if k <= G.GAME.scan_amount and cards_dont_match(card, scan_view.cards[i]) then
         local temp_card = copy_card(card, nil, 0.7)
         temp_card.states.drag.can = false
         temp_card.states.hover.can = false
         scan_view:emplace(temp_card)
         temp_card:start_materialize({G.C.PURPLE})
      end
      i = i + 1
   end
   G.E_MANAGER:add_event(Event({
      func = function()
         scan_view.adjusting_cards = false
         return true
      end,
   }))
end
