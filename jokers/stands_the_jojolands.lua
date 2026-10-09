-- The JOJOLands Stands

local smooth_operator = {
    name = "smooth_operator",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "the_jojolands",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 20 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.chips}}
   end,
    calculate = function(self, card, context)
        -- Before scoring, reposition all cards in played hand
        if context.before and context.cardarea == G.jokers and not context.blueprint and context.full_hand and #context.full_hand > 1 then
            local full_hand = context.full_hand
            for i = #full_hand, 2, -1 do
                local j = math.random(i)
                full_hand[i], full_hand[j] = full_hand[j], full_hand[i]
            end

            if G.play and G.play.cards then
                local played_set = {}
                for i = 1, #full_hand do
                    played_set[full_hand[i]] = true
                end

                local next_played_index = 1
                for i = 1, #G.play.cards do
                    if played_set[G.play.cards[i]] then
                        G.play.cards[i] = full_hand[next_played_index]
                        next_played_index = next_played_index + 1
                    end
                end
            end

            if context.scoring_hand then
                local position = {}
                for i = 1, #full_hand do
                    position[full_hand[i]] = i
                end

                table.sort(context.scoring_hand, function(a, b)
                    return (position[a] or 999) < (position[b] or 999)
                end)
            end

            return {
                message = localize("shuffled")
            }
        end

        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                    return {
                        message = localize{type = 'variable', key = 'a_chips', vars = {#context.scoring_hand * card.ability.extra.chips}},
                        colour = G.C.CHIPS,
                        chip_mod = #context.scoring_hand * card.ability.extra.chips,
                    }
                end
        end
    end
}

local john_rod = {
    name = "john_rod",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Long Range",
    part = "the_jojolands",
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.25, glass_Xmult_mod = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {vars = {center.ability.extra.Xmult_mod, center.ability.extra.glass_Xmult_mod, center.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.Xmult > 1 then
            sendDebugMessage("John Rod: Giving XMult of "..card.ability.extra.Xmult)
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                colour = G.C.XMULT,
                Xmult_mod = card.ability.extra.Xmult
            }
        end

        -- After scoring, destroy the highest ranked scored card (leftmost on ties) and gain XMult
        if context.destroy_card and context.cardarea == G.play and not context.blueprint then
            local highest_card
            for _, c in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(c) and (not highest_card or c:get_id() > highest_card:get_id()) then
                    highest_card = c
                end
            end

            if context.destroy_card == highest_card then
                local is_glass = SMODS.has_enhancement(highest_card, 'm_glass')
                local gain = is_glass and card.ability.extra.glass_Xmult_mod or card.ability.extra.Xmult_mod
                card.ability.extra.Xmult = card.ability.extra.Xmult + gain
                sendDebugMessage("John Rod: Destroying highest ranked card"..(is_glass and " (glass)" or "")..", XMult is now "..card.ability.extra.Xmult)
                return {
                    remove = true,
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    message_card = card
                }
            end
        end
    end
}

return {
    name = "The JOJOLands Stands Jokers",
    list = { smooth_operator, john_rod },
}