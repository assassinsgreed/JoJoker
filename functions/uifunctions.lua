-- Filters out all non-Jojoker cards based on config and optionally filters down collection pool
SMODS.collection_pool = function(_base_pool)
  local pool = {}
  if type(_base_pool) ~= 'table' then return pool end
  local is_array = _base_pool[1]
  local ipairs = is_array and ipairs or pairs
  for _, v in ipairs(_base_pool) do
    local moved = false
    if (not G.ACTIVE_MOD_UI or v.mod == G.ACTIVE_MOD_UI) and not v.no_collection then
      local empty_vanilla = v.set == 'Joker' and not v.part and jojoker_config.jojoker_only_collection
      if not moved and not empty_vanilla then pool[#pool+1] = v end
    end
  end

  if not is_array then table.sort(pool, function(a,b) return a.order < b.order end) end
  return pool
end