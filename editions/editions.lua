local apply_shader = function()
    SMODS.Shader({ key = 'menacing_aura', path = 'menacing_aura.fs'})
end

local menacing_aura = ({
    key = 'menacing_aura',
    disable_shadow = false,
    disable_base_shader = false,
    shader = 'menacing_aura',
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
        menacing_aura
    }
}