-- Steel Ball Run Stands

local mandom = {
    name = "mandom",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {retriggers = 1, card_max = 6, cards = 0}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.retriggers, center.ability.extra.card_max, center.ability.extra.card_max - center.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.repetition and not context.end_of_round and context.cardarea == G.play and card.ability.extra.cards < card.ability.extra.card_max then
            if not context.blueprint then
                card.ability.extra.cards = card.ability.extra.cards + 1
            end
            return {
                message = localize('sound_tick'),
                repetitions = card.ability.extra.retriggers,
                card = card
            }
            end
        if context.end_of_round and not context.individual and not context.repetition then
            card.ability.extra.cards = 0
        end
    end
}

local chocolate_disco = {
    name = "chocolate_disco",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {chips = 25, mult = 5}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            local anteIsOdd = G.GAME.round_resets.blind_ante % 2 == 1
            if anteIsOdd then
                -- In odd antes, give scored odd cards chips
                sendDebugMessage("Chocolate Disco: Adding "..card.ability.extra.chips.." chips to odd cards during odd ante.")
                if card_is_odd(context.other_card) then
                    return {
                        h_chips = card.ability.extra.chips,
                        card = card,
                    }
                end
            else
                -- In even antes, give scored even cards mult
                sendDebugMessage("Chocolate Disco: Adding "..card.ability.extra.mult.." mult to even cards during even ante.")
                if card_is_even(context.other_card) then
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                        colour = G.C.MULT,
                        mult_mod = card.ability.extra.mult
                    }
                end
            end
        end
    end
}

local oh_lonesome_me = {
    name = "oh_lonesome_me",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Long Range",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = {extra = {hand_size = 2}},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.hand_size}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end
}

local hey_ya = {
    name = "hey_ya",
    rarity = 3,
    cost = 9,
    jtype = "Stand",
    jclass = "Close Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 10 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.numerator, center.ability.extra.denominator }}
    end,
    calculate = function(self, card, context)
        -- If a lucky card is being scored, it always triggers
        if context.fix_probability then
            if context.identifier == 'lucky_mult' then
                return {
                    numerator = 1,
                    denominator = 1,
                }
            elseif context.identifier == 'lucky_money' then
                return {
                    numerator = 1,
                    denominator = 5,
                }
            end
        end
      
        -- For each scored queen, card, potentially make it lucky if it doesn't have an edition
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            if context.other_card.config.center == G.P_CENTERS.c_base then
                if SMODS.pseudorandom_probability(card, 'hey_ya', card.ability.extra.numerator, card.ability.extra.denominator, 'hey_ya') then
                    card:juice_up()
                    context.other_card:juice_up()
                    context.other_card:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    sendDebugMessage("Hey Ya: Scored card being set to lucky card")

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

return {
    name = "Steel Ball Run Stand Jokers",
    list = { mandom, chocolate_disco, oh_lonesome_me, hey_ya },
}