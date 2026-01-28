-- Jojolion Characters

local josuke_higashikata_jjl = {
    name = "josuke_higashikata_jjl",
    rarity = 2,
    cost = 5,
    jtype = "Character",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_four_fingers', config = {} }
      return {vars = {}}
    end
}

return {
    name = "Jojolion Characters Jokers",
    list = { josuke_higashikata_jjl },
}