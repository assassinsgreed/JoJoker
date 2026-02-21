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