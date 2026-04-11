-- Battle Tendency effects

local german_engineering = {
    name = "german_engineering",
    rarity = 1,
    cost = 3,
    jtype = "Effect",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- If scoring hand is a single 9, duplicate it and level up High Card
        if context.cardarea == G.jokers and context.scoring_hand then
                if #context.scoring_hand == 1 and context.scoring_hand[1]:get_id() == 9 then
                    if context.before and context.scoring_name == "High Card" then
                        local copy = copy_card(context.scoring_hand[1], nil, nil, G.playing_card)
                        copy:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, copy)
                        G.deck:emplace(copy)

                        SMODS.smart_level_up_hand(card, "High Card")
                        sendDebugMessage("German Engineering: Single 9 played. Duplicating and levelling up high card")
                        return {
                            message = localize('k_duplicated_ex')
                        }
                    end
                end
            -- end
        end
    end
}

local clacker_balls = {
    name = "clacker_balls",
    rarity = 1,
    cost = 5,
    jtype = "Effect",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {scored_hand_size = 3}},
    loc_vars = function(self, info_queue, center)
        return { vars = {center.ability.extra.scored_hand_size} }
    end,
    calculate = function(self, card, context)
        -- If scored hand is <= 3 cards, retrigger each scored card
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if not context.blueprint then
                if #context.scoring_hand <= 3 then
                    sendDebugMessage("Clacker Balls: Scored hand of " .. #context.scoring_hand .. " cards or fewer. Retriggering each scored card.")
                    return {
                        message = localize('k_retriggers_ex'),
                        extra = {
                            cards = #context.scoring_hand,
                            repetitions = 1,
                            card = card
                        }
                    }
                end
            end
        end
    end
}

return {
    name = "Battle Tendency Effects Jokers",
    list = { german_engineering, clacker_balls },
}