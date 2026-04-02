-- Stardust Crusaders Stands

local magician_red = {
    name = "magician_red",
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { money_mod = 5 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.money_mod}}
    end,
    calculate = function(self, card, context)
        -- Cache current hand score
        if context.cardarea == G.jokers and context.scoring_hand then
            if G.GAME.chips then
                G.GAME._chips_before_hand = G.GAME.chips
            end
        end

        -- If score catches fire, then earn $5
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if not G.GAME.chips or not G.GAME.blind.chips then return end
            local start = G.GAME._chips_before_hand or 0 -- fallback if missing
            local hand_score = (G.GAME.chips or 0) - start
            sendDebugMessage("Magician's Red: Recognized score at hand start as "..start)
            sendDebugMessage("Magician's Red: Resulting chips are "..hand_score.." and blind chips are "..G.GAME.blind.chips)
            
            -- Give money on flaming score
            if hand_score > G.GAME.blind.chips then
                ease_dollars(card.ability.extra.money_mod)
                return {
                    message = localize('$')..card.ability.extra.money_mod,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}

local yellow_temperance = {
    name = "yellow_temperance",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {retriggers = 1} },
    loc_vars = function(self, info_queue, center)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Retrigger all scored face cards
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

local star_platinum = {
    name = "star_platinum",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.numerator, center.ability.extra.denominator}}
    end,
    calculate = function(self, card, context)
        -- Potentially preserve hand when playing a hand (by adding 1 to remaining hands)
        if context.before and context.scoring_hand then
            if SMODS.pseudorandom_probability(card, 'star_platinum', card.ability.extra.numerator, card.ability.extra.denominator, 'star_platinum') then
                sendDebugMessage("Star Platinum: Preserving hand on played hand")
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1

                return {
                    message = localize("sound_time_moves")
                }
            end
        end
    end
}

local wheel_of_fortune = {
    name = "wheel_of_fortune",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Wheel of Fortune cards are guaranteed to trigger
        if context.fix_probability then
            if context.identifier == 'wheel_of_fortune' then
                sendDebugMessage("Wheel of Fortune is guaranteeing Wheel of Fortune tarot effect (if possible)")
                return {
                    numerator = 1,
                    denominator = 1,
                }
            end
        end
    end
}

local the_lovers = {
    name = "the_lovers",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Long Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 3 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.mult_mod }}
    end,
    calculate = function(self, card, context)
        -- Permanently gives +3 mult to each scored heart card
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") then
                if context.other_card.debuff then
                    return {
                        message = localize("k_debuffed"),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult_mod
                    context.other_card:juice_up()
                    sendDebugMessage("The Lovers: Increasing multiplier of scored heart to "..tostring(context.other_card.ability.perma_mult))

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

local anubis = {
    name = "anubis",
    rarity = 2,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 30, chips = 0 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips_mod, center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        -- When a Joker is sold, gain 30 chips.
        if context.selling_card and not context.selling_self then
            sendDebugMessage("Anubis: Gaining "..card.ability.extra.chips_mod.." chips from selling a joker")
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.GOLD
            }
        end

        -- Give accumulated chips when scoring a hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and card.ability.extra.chips > 0 then
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                }
            end
        end
    end
}

local sethan = {
    name = "sethan",
    rarity = 3,
    cost = 7,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.4, Xmult = 1 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.Xmult_mod, center.ability.extra.Xmult },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- When a hand is played, revert it's level to 1 then gain 0.4x multiplier for each level it used to have
        if context.before and context.scoring_hand then
            if not context.blueprint then
                local original_level = G.GAME.hands[context.scoring_name].level
                if original_level <= 1 then return end

                local downgraded_chips = G.GAME.hands[context.scoring_name].s_chips
                local downgraded_mult = G.GAME.hands[context.scoring_name].s_mult

                G.GAME.hands[context.scoring_name].level = 1
                G.GAME.hands[context.scoring_name].chips = downgraded_chips
                G.GAME.hands[context.scoring_name].mult = downgraded_mult

                local gained_xmult = (original_level - 1) * card.ability.extra.Xmult_mod
                card.ability.extra.Xmult = card.ability.extra.Xmult + gained_xmult
                sendDebugMessage("Sethan: Reverting hand level from "..original_level.." to 1 and increasing xmult by "..gained_xmult)

                -- Update the in-game text
                G.hand_text_area.hand_level:juice_up()
                update_hand_text(
                    { sound = 'button', volume = 0.7, pitch = 1.1, delay = 0},
                    {mult = downgraded_mult, chips = downgraded_chips, handname = context.scoring_name, level = '1'})

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            end
        end

        -- Give accumulated xmult when scoring a hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local the_world = {
    name = "the_world",
    rarity = 4,
    cost = 10,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { Xmult_mod = 1, Xmult = 1, known_consumeables = {} } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        -- If a consumable tarot card is used and isn't known, add it to the list and display flavor text
        if context.using_consumeable then
            if context.consumeable.ability.set == 'Tarot' and not card.ability.extra.known_consumeables[context.consumeable.ability.name] then
                card.ability.extra.known_consumeables[context.consumeable.ability.name] = true
                sendDebugMessage("The World: Recognized use of new tarot card "..context.consumeable.ability.name..", increasing xmult by "..card.ability.extra.Xmult_mod)

                return {
                    message = localize('sound_za_warudo'),
                    colour = G.C.GOLD
                }
            end
        end

        -- For each unique tarot card played, gains XMult
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
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local tarot_cards_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Tarot' then tarot_cards_used = tarot_cards_used + 1 end
            end
            card.ability.extra.Xmult = 1 + tarot_cards_used * card.ability.extra.Xmult_mod
        end
    end
}

return {
    name = "Stardust Crusaders Stand Jokers",
    list = { magician_red, yellow_temperance, star_platinum, wheel_of_fortune, the_lovers, anubis, sethan, the_world },
}