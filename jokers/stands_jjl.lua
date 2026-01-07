-- Jojolion Stands

local soft_and_wet = {
    name = "soft_and_wet",
    pos = { x = 0, y = 0 }, -- Index in spritesheet
    rarity = 2,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = false,
    config = { mult_mod = 10 },
    calculate = function(self, card, context)
        -- Apply mult
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local m_count = 0
            local enhanced = {}
            for k,v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vapired then
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    
                    if v.config.center == G.P_CENTERS.m_mult or v.config.center == G.P_CENTERS.m_wild or v.config.center == G.P_CENTERS.m_bonus or v.config.center == G.P_CENTERS.m_stone or v.config.center == G.P_CENTERS.m_steel or v.config.center == G.P_CENTERS.m_glass or v.config.center == G.P_CENTERS.m_gold or v.config.center == G.P_CENTERS.m_lucky then
                        m_count = m_count + 1
                    end
                    v:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v.vampired = nil
                            return true
                        end
                    }))
                end
            end

            if #enhanced > 0 and m_count > 0 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * m_count
            end
        end

        -- Sound effect
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                message = localize("sound_ora"),
                colour = G.C.BLACK,
                mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}

return {
    name = "Jojolion Stands Jokers",
    list = { soft_and_wet },
}