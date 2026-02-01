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
        config = { extra = { mult = 0, position = nil, manually_repositioned = false, relocated_this_blind = false } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult}}
   end,
    calculate = function(self, card, context)
        -- At the start of blind, relocate and reset position state
        if context.setting_blind then
            if not card.ability.extra.relocated_this_blind then
                local card_index = find_joker_pos(card)
                sendDebugMessage("Smooth Operator: Found at position "..card_index)

                -- Relocate itself
                if card_index and #G.jokers.cards > 1 then
                    table.remove(G.jokers.cards, card_index)
                    local new_index = card_index
                    while new_index == card_index do
                        new_index = math.random(1, #G.jokers.cards + 1)
                    end
                    table.insert(G.jokers.cards, new_index, card)
                    card.ability.extra.position = new_index
                    card.ability.extra.relocated_this_blind = true
                    card.ability.extra.manually_repositioned = false
                    sendDebugMessage("Smooth Operator: Relocated to position " .. card.ability.extra.position)
                end
            end
        end

        if context.cardarea == G.jokers and context.scoring_hand then
            local card_index = find_joker_pos(card)
            if card_index and card.ability.extra.position ~= card_index then
                card.ability.extra.manually_repositioned = true
                sendDebugMessage("Smooth Operator: Manually repositioned this blind.")
            end
        end

        -- Increase mult by # of jokers at the end of the blind, if this joker hasn't moved
        if context.end_of_round and not context.individual and not context.repetition then
            card.ability.extra.relocated_this_blind = false
            local card_index = find_joker_pos(card)
            
            if card.ability.extra.position == card_index and not card.ability.extra.manually_repositioned then
                local held_jokers = #G.jokers.cards
                card.ability.extra.mult = card.ability.extra.mult + held_jokers
                sendDebugMessage("Smooth Operator: Not relocated, adding "..held_jokers.." to mult. Mult is now ".. card.ability.extra.mult)
            end
        end

        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                }
            end
        end
    end
}

return {
    name = "The JOJOLands Stands Jokers",
    list = { smooth_operator },
}