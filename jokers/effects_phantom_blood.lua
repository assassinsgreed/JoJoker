-- Phantom Blood Effects

local sword_of_luck_and_pluck = {
    name = "sword_of_luck_and_pluck",
    rarity = 3,
    cost = 5,
    jtype = "Effect",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { trigger_rate = 3 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.trigger_rate }}
    end,
    calculate = function(self, card, context)
        -- Lucky cards have a 3x chance of triggering
        if context.fix_probability then
            if context.identifier == 'lucky_mult' or context.identifier == 'lucky_money' then
                return {
                    denominator = math.ceil(context.denominator / 3),
                }
            end
        end
    end
}

return {
    name = "Phantom Blood Effect Jokers",
    list = { sword_of_luck_and_pluck },
}