-- Stone Ocean Stands

local goo_goo_dolls = {
    name = "goo_goo_dolls",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult}}
   end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            local id = context.other_card:get_id()
            if id and id >= 2 and id <= 6 then
                sendDebugMessage("Goo Goo Dolls: Scored card is rank: "..id)
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

local stone_free = {
    name = "stone_free",
    rarity = 2,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    config = {extra = {retriggers = 1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.retriggers}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card.config.center == G.P_CENTERS.m_stone then
                sendDebugMessage("Stone Free: Retriggering stone card")
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

local made_in_heaven = {
    name = "made_in_heaven",
    rarity = 4,
    cost = 10,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = {extra = {hands = 1, discards = 0, Xmult = 1, Xmult_mod = 1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.hands, center.ability.extra.discards, center.ability.extra.Xmult, center.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        -- Reduce hands to 1, discards to 0, and increase hand size to deck size. Gains 0.5x mult per hand and discard lost
        if context.setting_blind and not context.blueprint then
            local hands_mult = card.ability.extra.Xmult_mod * (G.GAME.current_round.hands_left - 1)
            local discards_mult = card.ability.extra.Xmult_mod * G.GAME.current_round.discards_left
            card.ability.extra.Xmult = hands_mult + discards_mult
            sendDebugMessage("Made In Heaven: Setting Xmult to "..card.ability.extra.Xmult)

            if G.hand.config.card_limit < #G.deck.cards then
                G.hand:change_size(#G.deck.cards)
                G.GAME.round_resets.temp_handsize = #G.deck.cards
            end
            ease_discard(-G.GAME.current_round.discards_left, nil, true)
            if G.GAME.blind.name ~= "The Needle" then
                ease_hands_played(-G.GAME.current_round.hands_left + 1)
            end
        end

        if context.joker_main then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                colour = G.C.XMULT,
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,
    in_pool = function(self, args)
        return not args or args.source ~= "jud"
    end
}

return {
    name = "Stone Ocean Stands Jokers",
    list = { goo_goo_dolls, stone_free, made_in_heaven },
}