local apply_shader = function()
    SMODS.Shader({ key = 'legendary_joker', path = 'legendary_joker.fs'})
end

local legendary = ({
    key = 'legendary',
    disable_shadow = false,
    disable_base_shader = false,
    shader = 'legendary_joker',
    discovered = true,
    unlocked = true,
    config = {},
    in_shop = false, -- Prevent from spawning on random jokers
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {} }
    end
})

return {
    name = 'Editions',
    init = apply_shader,
    list = {
        legendary
    }
}