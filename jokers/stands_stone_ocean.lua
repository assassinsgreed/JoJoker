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
     return {
        vars = {center.ability.extra.mult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
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
        return {
            vars = {center.ability.extra.retriggers},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
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
        return {
            vars = {center.ability.extra.hands, center.ability.extra.discards, center.ability.extra.Xmult, center.ability.extra.Xmult_mod},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
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
        return {
            vars = {
                center.ability.extra.chip_mod,
                center.ability.extra.mult_mod,
                center.ability.extra.money_mod,
                center.ability.extra.xmult_mod,
                center.ability.extra.curr_chips,
                center.ability.extra.curr_mult,
                center.ability.extra.curr_money,
                center.ability.extra.curr_Xmult},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
            }
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

local green_green_grass_of_home = {
    name = "green_green_grass_of_home",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = { Xchips = 2 }},
    loc_vars = function(self, info_queue, center)
        return {
            vars = { center.ability.extra.Xchips },
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
       -- When high card is played, double earned chips
       if context.cardarea == G.jokers and context.scoring_hand and context.scoring_name == "High Card" then
            if context.joker_main then
                sendDebugMessage("Green, Green Grass of Home: Doubling chips for high card")
                hand_chips = hand_chips * card.ability.extra.Xchips

                return {
                    message = localize('sound_gaa')
                }
            end
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

local foo_fighters = {
    name = "foo_fighters",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 5, chips = 0 } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {center.ability.extra.chips_mod, center.ability.extra.chips},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        -- When high card is played, double earned chips
       if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Foo Fighters: Giving chips based on unique cards played this ante. Chips to add: "..card.ability.extra.chips)

                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local unique_cards_played_this_ante = 0
            for k, v in ipairs(G.playing_cards) do
                unique_cards_played_this_ante = unique_cards_played_this_ante + (v.ability.played_this_ante and 1 or 0)
            end
            card.ability.extra.chips = card.ability.extra.chips_mod * unique_cards_played_this_ante
        end
    end
}

local white_snake = {
    name = "white_snake",
    rarity = 3,
    cost = 6,
    jtype = "Stand",
    jclass = "Long Range",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 3 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.numerator, center.ability.extra.denominator },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- For each scored queen, card, potentially make it wild if it doesn't have an enhancement
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            if context.other_card.config.center == G.P_CENTERS.c_base then
                if SMODS.pseudorandom_probability(card, 'white_snake', card.ability.extra.numerator, card.ability.extra.denominator, 'white_snake') then
                    card:juice_up()
                    context.other_card:juice_up()
                    context.other_card:set_ability(G.P_CENTERS.m_wild, nil, true)
                    sendDebugMessage("White Snake: Scored card being set to wild")

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

local burning_down_the_house = {
    name = "burning_down_the_house",
    rarity = 3,
    cost = 10,
    jtype = "Stand",
    jclass = "Automatic",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- If held on loss, is destroyed and skips blind without entering the shop
        if context.end_of_round and context.main_eval and context.game_over then
            sendDebugMessage("Burning Down The House: Preventing loss, destroying self, and skipping blind. ")

            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.8,
                blockable = false, 
                func = function()
                    -- Destroy Burning Down The House
                    G.GAME.joker_buffer = 0
                    card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    remove(self, card, context, true)
                    return true
                end
            }))

            return {
                message = localize('k_saved_ex'),
                saved = 'sound_saved_by_bdth',
            }
        end
    end
}

local limp_bizkit = {
    name = "limp_bizkit",
    rarity = 2,
    cost = 8,
    jtype = "Stand",
    jclass = "Automatic",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 2 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.numerator, center.ability.extra.denominator},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
      }
    end,
    calculate = function(self, card, context)
        -- Potentially convert joker to negative on destruction
        if context.joker_type_destroyed then
            if SMODS.pseudorandom_probability(card, 'limp_bizkit', card.ability.extra.numerator, card.ability.extra.denominator, 'limp_bizkit') then
                sendDebugMessage("Limp Bizkit: Joker being recreated as Negative")
                card:juice_up()

                SMODS.add_card {
                    key = context.card.config.center.key,
                    edition = "e_negative",
                }

                return {
                    message = localize('k_copied_ex'),
                    reborn = 'sound_limp_bizkit_reborn'
                }
            end
        end
    end
}

local marilyn_manson = {
    name = "marilyn_manson",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Long Range",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { debt = 15, debt_repay = 2 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.debt, center.ability.extra.debt_repay},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
      }
    end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.current_round.discards_left == 0 then
            sendDebugMessage("Marilyn Manson: Giving $"..card.ability.extra.debt_repay.." because 0 discards remain.")
            return ease_joker_dollars(card, "Marilyn Manson", card.ability.extra.debt_repay, true)
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt
    end,
}

local c_moon = {
    name = "c_moon",
    rarity = 3,
    cost = 8,
    jtype = "Stand",
    jclass = "Long Range",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, center)
        return {
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            sendDebugMessage("C-Moon: Equalizing chips and mult")
            local total = hand_chips + mult
            hand_chips = math.floor(total / 2)
            mult = math.floor(total / 2)
            update_hand_text({delay = 0}, {mult = mult, chips = hand_chips})

            G.E_MANAGER:add_event(Event({
                func = (function()
                    local text = localize('k_balanced')
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94*1.5, 0.2)
                    play_sound('tarot1', 1.5)
                    ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                    ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                    attention_text({
                        scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay =  4.3,
                        func = (function() 
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay =  6.3,
                        func = (function() 
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                end)
            }))

            delay(0.6)
        end
    end
}

local planet_waves = {
    name = "planet_waves",
    rarity = 3,
    cost = 7,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 3 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.numerator, center.ability.extra.denominator}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == 'Planet' then
                if SMODS.pseudorandom_probability(card, 'planet_waves', card.ability.extra.numerator, card.ability.extra.denominator, 'planet_waves') then
                    sendDebugMessage("Planet Waves: Duplicating played planet card")

                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        local _card = SMODS.create_card({
                            set = "Planet",
                            area = G.consumeables,
                            key = context.consumeable.config.center.key
                        })
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                        return true end })
                    )

                    return {
                        message = localize('k_copied_ex')
                    }
                end
            end
        end
    end
}

return {
    name = "Stone Ocean Stands Jokers",
    list = { goo_goo_dolls, stone_free, made_in_heaven, dragons_dream, green_green_grass_of_home, survivor, foo_fighters, white_snake, burning_down_the_house, limp_bizkit, marilyn_manson, c_moon, planet_waves },
}