-- Jojolion Stands

local soft_and_wet = {
    name = "soft_and_wet",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = false,
    config = { extra = { mult = 0, mult_mod = 10 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult, center.ability.extra.mult_mod}}
   end,
    calculate = function(self, card, context)
        local m_count = 0
        local popped = false

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
                        popped = true
                        v:set_ability(G.P_CENTERS.c_base, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                v.vampired = nil
                                return true
                            end
                        }))
                    end
                end
            end

            if #enhanced > 0 and m_count > 0 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * m_count
            end
            sendDebugMessage("Soft & Wet removed " .. #enhanced .. " enhancements. Mult is now " .. card.ability.extra.mult)

            if popped then
                popped = false
                return {
                    message = localize("sound_pop")
                }
            end
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

local paper_moon_king = {
    name = "paper_moon_king",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_pareidolia', config = {} }
      return {vars = {}}
    end
}

local milagro_man = {
    name = "milagro_man",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    calc_dollar_bonus = function(self, card)
        local doubled_up = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)
        sendDebugMessage("Milagro Man: Doubling interest to $"..doubled_up)
        return ease_joker_dollars(card, "Milagro Man", doubled_up, true)
	end
}

local i_am_a_rock = {
    name = "i_am_a_rock",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, center)
      return {key = jojoker_config.use_localized_names and self.key..'_alt' or self.key}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end

        -- Set unscored cards to stone cards, if they don't have another enhancement
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            for _, unscored_card in pairs(context.full_hand) do
                if not SMODS.in_scoring(unscored_card, context.scoring_hand) then
                    if unscored_card.config.center == G.P_CENTERS.c_base and not unscored_card.debuff and not unscored_card.vampired then
                        unscored_card:set_ability(G.P_CENTERS.m_stone, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                unscored_card:juice_up()
                                return true
                            end
                        }))
                        sendDebugMessage("I Am A Rock: Unscored card being set to stone")
                    end
                end
            end
        end
    end
}

local california_king_bed = {
    name = "california_king_bed",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "jojolion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.5, Xmult = 1, tracked_hands = {} } },
    loc_vars = function(self, info_queue, center)
     return {
        vars = {center.ability.extra.Xmult_mod, center.ability.extra.Xmult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Before scoring, increase XMult if hand has not been played this round
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint then
                if context.before and card.ability.extra.tracked_hands[context.scoring_name] == nil then
                    card.ability.extra.tracked_hands[context.scoring_name] = true
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    sendDebugMessage("California King Bed: Adding scoring hand '"..context.scoring_name.."' to tracked hands and increasing XMult")
                    return {
                        message = localize('k_upgrade_ex')
                    }
                end

                -- During scoring, give XMult
                if context.joker_main then
                    return {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                        colour = G.C.XMULT,
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            end
        end

        -- When blind ends, reset XMult and pool of tracked hands
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.Xmult = 1
            card.ability.extra.tracked_hands = {}
            sendDebugMessage("California King Bed: Resetting joker at the end of the round.")
        end
    end
}

return {
    name = "Jojolion Stands Jokers",
    list = { soft_and_wet, paper_moon_king, milagro_man, i_am_a_rock, california_king_bed },
}