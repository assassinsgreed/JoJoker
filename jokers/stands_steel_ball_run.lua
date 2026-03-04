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
        return {
            vars = {center.ability.extra.retriggers, center.ability.extra.card_max, center.ability.extra.card_max - center.ability.extra.cards},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
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

local tattoo_you = {
    name = "tattoo_you",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { }},
    loc_vars = function(self, info_queue, center)
        return {vars = { }}
    end,
    calculate = function(self, card, context)
        -- Convert a random scored non-Jack to a Jack
        if context.final_scoring_step and not context.blueprint then
            if context.scoring_hand then
                local non_jacks = {}
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() ~= 11 then
                        non_jacks[#non_jacks + 1] = context.scoring_hand[i]
                    end
                end

                if #non_jacks == 0 then
                    sendDebugMessage("TATTOO YOU!: No non-Jack cards in scored hand, cannot convert to Jack.")
                    return
                end

                local chosen_card = non_jacks[math.random(#non_jacks)]
                local suit_to_prefix = { Spades = 'S', Hearts = 'H', Clubs = 'C', Diamonds = 'D' }
                local suit_prefix = suit_to_prefix[chosen_card.base.suit]

                -- Trigger event to convert the chosen card to a Jack after scoring has completed
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0,
                    func = function()
                        chosen_card:set_base(G.P_CARDS[suit_prefix..'_J'])
                        chosen_card:juice_up()
                        sendDebugMessage("TATTOO YOU!: Converted a non-Jack card to Jack.")
                        return true
                    end
                }))

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD,
                    card = chosen_card
                }
            end
        end
    end
}

local civil_war = {
    name = "civil_war",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 20, chips = 0 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips_mod, center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        -- When skipping a booster, gain chips
        if context.skipping_booster then
            sendDebugMessage("Civil War: Gaining "..card.ability.extra.chips_mod.." chips for skipping booster.")
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
            }
        end

        -- Give chips during scorinng
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Civil War: Adding "..card.ability.extra.chips.." chips to hand during scoring.")
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                }
            end
        end
    end
}

return {
    name = "Steel Ball Run Stand Jokers",
    list = { mandom, chocolate_disco, oh_lonesome_me, hey_ya, tattoo_you, civil_war },
}