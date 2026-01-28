-- Steel Ball Run Effects

local the_fifth_lesson = {
    name = "the_fifth_lesson",
    rarity = 2,
    cost = 5,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_shortcut', config = {} }
        return {vars = {}}
    end
}

return {
    name = "Steel Ball Run Effects Jokers",
    list = { the_fifth_lesson },
}