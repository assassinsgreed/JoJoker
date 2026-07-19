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

return {
    name = "The JOJOLands Stands Jokers",
    list = { smooth_operator },
}