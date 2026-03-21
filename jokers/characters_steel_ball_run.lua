-- Steel Ball Run Characters

local danny_sbr = {
    name = "danny_sbr",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { Xmult = 2 }},
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if #G.jokers.cards > 0 then
            -- Destroy a random joker that is not Danny SBR
            local danny_index = find_joker_pos(card)
            local joker_to_destroy_index = danny_index

            while joker_to_destroy_index == danny_index do
                joker_to_destroy_index = math.random(1, #G.jokers.cards - 1)
            end

            sendDebugMessage("Danny is destroying joker at index " .. joker_to_destroy_index.." ("..G.jokers.cards[joker_to_destroy_index].ability.name..")")
            local destroyed_joker = G.jokers.cards[joker_to_destroy_index]
            destroyed_joker.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.joker_buffer = 0
                    card_eval_status_text(destroyed_joker, 'extra', nil, nil, nil, {message = localize('sound_retired')})
                    destroyed_joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    return true
                end
            }))
        end
    end,
}

local slow_dancer = {
    name = "slow_dancer",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { mult = 15, previous_hand = 0 }},
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.mult, center.ability.extra.previous_hand }}
    end,
    calculate = function(self, card, context)
        -- Give mult for each scored card > than the previous hand's scored cards
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local scored_cards = #context.scoring_hand
                local mult_given = 0

                if (scored_cards > card.ability.extra.previous_hand) and card.ability.extra.previous_hand > 0 then
                    mult_given = (scored_cards - card.ability.extra.previous_hand) * card.ability.extra.mult
                end

                card.ability.extra.previous_hand = scored_cards
                sendDebugMessage("Slow Dancer: scored_cards = "..scored_cards..", previous_hand = "..card.ability.extra.previous_hand..", mult_given = "..mult_given)
                if mult_given > 0 then
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {mult_given}},
                        colour = G.C.MULT,
                        mult_mod = mult_given
                    }
                end
            end
        end
    end,
}

local valkyrie = {
    name = "valkyrie",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { card_threshold = 8, chips_per_card = 3, scored_cards_remaining = 8, chip_payout = 0 }},
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.card_threshold, center.ability.extra.chips_per_card, center.ability.extra.scored_cards_remaining, center.ability.extra.chip_payout }}
    end,
    calculate = function(self, card, context)
        -- After every 8 scored cards, give chips based on remaining total of cards in the deck
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local scored_cards = #context.scoring_hand
                local remaining = card.ability.extra.scored_cards_remaining - scored_cards
                local should_trigger = false

                if remaining <= 0 then
                    sendDebugMessage("Valkyrie: Played enough scoring cards, with spill-over of "..remaining..", will give chips")
                    card.ability.extra.scored_cards_remaining = card.ability.extra.card_threshold + remaining -- This is a negative value
                    should_trigger = true
                else
                    sendDebugMessage("Valkyrie: Did not play enough scoring cards, remaining until activation is "..remaining)
                    card.ability.extra.scored_cards_remaining = remaining
                end

                if should_trigger then
                    return {
                        message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chip_payout}},
                        colour = G.C.CHIPS,
                        chip_mod = card.ability.extra.chip_payout
                    }
                end
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.chip_payout = #G.deck.cards * card.ability.extra.chips_per_card
        end
    end
}

return {
    name = "Steel Ball Run Characters Jokers",
    list = { danny_sbr, slow_dancer, valkyrie },
}