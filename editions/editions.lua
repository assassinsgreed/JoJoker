local apply_shader = function()
    SMODS.Shader({ key = 'menacing_aura', path = 'menacing_aura.fs'})

    SMODS.DrawStep {
        key = 'menacing_aura',
        order = 21,
        conditions = { vortex = false, facing = 'front' },
        func = function(card)
            local center = card.config.center
            if card.ability.set ~= 'Joker' then return end
            if type(center) ~= 'table' or center.rarity ~= 4 then return end
            if center.stage or center.menacing_aura then return end

            card.children.center:draw_shader('jojoker_menacing_aura', nil, card.ARGS.send_to_shader)
        end,
    }
end

return {
    name = 'Editions',
    init = apply_shader,
    list = {}
}
