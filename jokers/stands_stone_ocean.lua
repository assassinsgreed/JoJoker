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

local dragons_dream = {
    name = "dragons_dream",
    rarity = 2,
    cost = 7,
    jtype = "Stand",
    jclass = "Automatic",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {
        chip_mod = 15,
        mult_mod = 5,
        money_mod = 1,
        xmult_mod = 0.2,
        curr_chips = 15,
        curr_mult = 5,
        curr_money = 1,
        curr_Xmult = 1}},
    loc_vars = function(self, info_queue, center)
        return {vars = {
            center.ability.extra.chip_mod,
            center.ability.extra.mult_mod,
            center.ability.extra.money_mod,
            center.ability.extra.xmult_mod,
            center.ability.extra.curr_chips,
            center.ability.extra.curr_mult,
            center.ability.extra.curr_money,
            center.ability.extra.curr_Xmult}}
    end,
    calculate = function(self, card, context)
        -- When hand played, randomly change values
        if context.before and context.scoring_hand then
            if not context.blueprint then
                local chosenValue = math.random(0, 3)
                local add_remove = math.random(0, 1) == 0 and -1 or 1
                local modValue = nil
                local modText = nil
                
                if (chosenValue == 0) then
                    modValue = add_remove * card.ability.extra.chip_mod
                    card.ability.extra.curr_chips = math.max(0, card.ability.extra.curr_chips + modValue)
                    modText = (add_remove == 1 and "+" or "-")..math.abs(modValue).." "..localize("chips")
                    sendDebugMessage("Dragon's Dream: Changing chips by "..modValue..", new value: "..card.ability.extra.curr_chips)
                elseif (chosenValue == 1) then
                    modValue = add_remove * card.ability.extra.mult_mod
                    card.ability.extra.curr_mult = math.max(0, card.ability.extra.curr_mult + modValue)
                    modText = (add_remove == 1 and "+" or "-")..math.abs(modValue).." "..localize("k_mult")
                    sendDebugMessage("Dragon's Dream: Changing mult by "..modValue..", new value: "..card.ability.extra.curr_mult)
                elseif (chosenValue == 2) then
                    modValue = add_remove * card.ability.extra.money_mod
                    card.ability.extra.curr_money = math.max(0, card.ability.extra.curr_money + modValue)
                    modText = (add_remove == 1 and "+" or "-")..localize('$')..math.abs(modValue)
                    sendDebugMessage("Dragon's Dream: Changing money by "..modValue..", new value: "..card.ability.extra.curr_money)
                elseif (chosenValue == 3) then
                    modValue = add_remove * card.ability.extra.xmult_mod
                    card.ability.extra.curr_Xmult = math.max(0, card.ability.extra.curr_Xmult + modValue)
                    modText = (add_remove == 1 and "+" or "-")..math.abs(modValue).." "..localize("xmult")
                    sendDebugMessage("Dragon's Dream: Changing Xmult by "..modValue..", new value: "..card.ability.extra.curr_Xmult)
                end

                card:juice_up()
                ease_dollars(card.ability.extra.curr_money)
                return {
                    message = localize(add_remove == 1 and 'sound_lucky' or 'sound_unlucky').." "..modText,
                }
            end
        end

        -- Print out result on joker application
        if context.joker_main then
            return {
                message = localize('sound_neutral'),
                chip_mod = card.ability.extra.curr_chips,
                mult_mod = card.ability.extra.curr_mult,
                Xmult_mod = card.ability.extra.curr_Xmult,
            }
        end
    end
}

local survivor = {
    name = "survivor",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Automatic",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_splash', config = {} }
      return {vars = {}}
    end
}

return {
    name = "Stone Ocean Stands Jokers",
    list = { goo_goo_dolls, stone_free, made_in_heaven, dragons_dream, survivor },
}