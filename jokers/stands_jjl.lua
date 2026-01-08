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
    config = { extra = { mult = 0, mult_mod = 8 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult, center.ability.extra.mult_mod}}
   end,
    calculate = function(self, card, context)
        local m_count = 0

        -- Apply mult
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local enhanced = {}
            local mult_centers = {
                [G.P_CENTERS.m_mult] = true,
                [G.P_CENTERS.m_wild] = true,
                [G.P_CENTERS.m_bonus] = true,
                [G.P_CENTERS.m_stone] = true,
                [G.P_CENTERS.m_steel] = true,
                [G.P_CENTERS.m_glass] = true,
                [G.P_CENTERS.m_gold] = true,
                [G.P_CENTERS.m_lucky] = true,
            }
            for k,v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    
                    if mult_centers[v.config.center] then
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
            sendDebugMessage("Soft & Wet removed " .. #enhanced .. " enhancements. Mult is now " .. card.ability.extra.mult)
        end

        -- Sound effect
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
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