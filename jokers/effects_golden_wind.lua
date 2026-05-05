-- Golden Wind effects

local epitaph = {
    name = "epitaph",
    rarity = 2,
    cost = 6,
    jtype = "Effect",
    part = "golden_wind",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { cards = 4 } },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {set = 'Other', key = 'scan_cards'}
        return {
            vars = {center.ability.extra.cards},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        -- Reveal top 4 cards of deck as prediction and add their chips to scored handler
        if not context.end_of_round and context.scoring_hand then
            if context.individual and context.cardarea == G.scan_view and not context.other_card.debuff then
                local chips = joker_total_chips(context.other_card)
                sendDebugMessage("Epitaph is giving " .. chips .. " chips based on scanned cards")
                return {
                    message = localize{type = 'variable', key = 'a_chips', vars = {chips}},
                    message_card = context.other_card,
                    colour = G.C.CHIPS,
                    chip_mod = chips,
                    card = card,
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.scan_amount = (G.GAME.scan_amount or 0) + card.ability.extra.cards
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.scan_amount = math.max(0,(G.GAME.scan_amount or 0) - card.ability.extra.cards)
    end
}

local seven_page_muda = {
    name = "seven_page_muda",
    rarity = 2,
    cost = 7,
    jtype = "Effect",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { has_triggered_this_blind = false } },
    calculate = function(self, card, context)
        if context.repetition and not context.end_of_round and context.cardarea == G.play and not card.ability.extra.has_triggered_this_blind then
            if context.other_card:get_id() == 7 then
                card.ability.extra.has_triggered_this_blind = true
                return {
                    message = localize('sound_muda'),
                    repetitions = 7,
                    card = card
                }
            end
        end
        if context.end_of_round and not context.individual and not context.repetition then
            card.ability.extra.has_triggered_this_blind = false
        end
    end
}

return {
    name = "Golden Wind Effect Jokers",
    list = { epitaph, seven_page_muda },
}