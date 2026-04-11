-- Golden Wind stands

local sex_pistols = {
    name = "sex_pistols",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 0, chosen_rank = "undecided", deactivated = false } }, -- Default for displayed strings in desc
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.chosen_rank},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        -- When blind is starting, choose a random rank
        local rank_options = {"Ace", "2", "3", "5", "6", "7"}
        if context.setting_blind then
            local chosenRank = rank_options[math.random(#rank_options)]
            card.ability.extra.chosen_rank = chosenRank
            sendDebugMessage("Sex Pistols: Chose rank "..chosenRank)
        end

        -- When a hand is scored, if rank is present in scoring hand then boost joker mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.initial_scoring_step then
                if not context.blueprint then
                    for k, v in pairs(context.scoring_hand) do
                        local rank = v:get_id()
                        if not v.debuff and tostring(rank) == card.ability.extra.chosen_rank or rank == 14 and card.ability.extra.chosen_rank == "Ace" then
                            if not card.ability.extra.deactivated then
                                sendDebugMessage("Sex Pistols: Found match rank for "..card.ability.extra.chosen_rank)
                                if card.ability.extra.chosen_rank == "Ace" then
                                    card.ability.extra.mult = card.ability.extra.mult + 1
                                else
                                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.chosen_rank
                                end
                                card.ability.extra.deactivated = true
                                return {
                                    message = localize('k_upgrade_ex'),
                                    colour = G.C.MULT
                                }
                            end
                        end
                    end
                end
            end

            if context.joker_main then
                if card.ability.extra.mult > 0 then
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                        colour = G.C.MULT,
                        mult_mod = card.ability.extra.mult
                    }
                else
                    return {
                        message = localize("sound_mista")
                    }
                end
            end
        end

        -- When blind ends, reset display strings
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.chosen_rank = localize("undecided")
            card.ability.extra.deactivated = false
        end
    end
}

local grateful_dead = {
    name = "grateful_dead",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { starting_mult = 25, mult_decay = 5, mult = 25, } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.starting_mult, card.ability.extra.mult_decay, card.ability.extra.mult},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        -- Give mult during scoring
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult
                }
            end
        end

        -- When blind is ending, decay mult
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.mult_decay)
            sendDebugMessage("Grateful Dead: Decayed mult to "..card.ability.extra.mult)
        end
    end
}

local spice_girl = {
    name = "spice_girl",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 25, Xmult_mod = 0.25, chips = 0, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips_mod, card.ability.extra.Xmult_mod, card.ability.extra.chips, card.ability.extra.Xmult},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end,
    calculate = function(self, card, context)
        -- When a stone card or steel card is scored, remove it's enhancement and boost joker chips and mult
        if context.cardarea == G.play then
            if not context.blueprint then
                for k, v in pairs(context.scoring_hand) do
                    -- Handle stone and steel cards
                    if v.config.center == G.P_CENTERS.m_stone or v.config.center == G.P_CENTERS.m_steel then
                        if v.config.center == G.P_CENTERS.m_stone then
                            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
                            sendDebugMessage("Spice Girl removed stone enhancement. Chips are now "..card.ability.extra.chips)
                        else
                            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                            sendDebugMessage("Spice Girl removed steel enhancement. Xmult is now "..card.ability.extra.Xmult)
                        end
                        
                        v:set_ability(G.P_CENTERS.c_base, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                v.vampired = nil
                                return true
                            end
                        }))
                    end
                end
            end
        end

        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour=G.C.CHIPS,
                    chip_mod=card.ability.extra.chips,
                    mult_mod=card.ability.extra.Xmult,
                }
            end
        end
    end
}

local sticky_fingers = {
    name = "sticky_fingers",
    rarity = 2,
    cost = 5,
    jtype = "Character",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_four_fingers', config = {} }
        return {
            vars = {},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
        }
    end
}

local gold_experience = {
    name = "gold_experience",
    rarity = 3,
    cost = 7,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 10 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.numerator, center.ability.extra.denominator },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- For each scored card, potentially make it polychrome if it doesn't have an edition
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            if not context.other_card.edition then
                if SMODS.pseudorandom_probability(card, 'gold_experience', card.ability.extra.numerator, card.ability.extra.denominator, 'gold_experience') then
                    card:juice_up()
                    context.other_card:juice_up()
                    context.other_card:set_edition("e_polychrome")
                    sendDebugMessage("Gold Experience: Scored card being set to polychrome")

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}

local gold_experience_requiem = {
    name = "gold_experience_requiem",
    rarity = 3,
    cost = 7,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Disables active boss blinds
        if context.setting_blind then
            if G.GAME.blind and G.GAME.blind:get_type() == 'Boss' then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                G.GAME.blind:disable()
            end
        end
    end
}

local king_crimson = {
    name = "king_crimson",
    rarity = 4,
    cost = 10,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { Xmult_mod = 2, Xmult = 1, } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = { center.ability.extra.Xmult_mod, center.ability.extra.Xmult },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Gives 2x mult for each skipped blind
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("King Crimson: Giving "..card.ability.extra.Xmult.."x mult for "..G.GAME.skips.." skips")
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
            card.ability.extra.Xmult = 1 + card.ability.extra.Xmult_mod * G.GAME.skips
        end
    end
}

local moody_blues = {
    name = "moody_blues",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 3, retriggers = 1 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.numerator, center.ability.extra.denominator},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Potentially retrigger a card during scoring
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, 'moody_blues', card.ability.extra.numerator, card.ability.extra.denominator, 'moody_blues') then
                card:juice_up()
                context.other_card:juice_up()
                sendDebugMessage("Moody Blues: Retriggering scored card")
                
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

local baby_face = {
    name = "baby_face",
    rarity = 3,
    cost = 9,
    jtype = "Stand",
    jclass = "Automatic",
    part = "golden_wind",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 5 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.numerator, center.ability.extra.denominator},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- At end of blind, have a chance to create a negative common joker
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'baby_face', card.ability.extra.numerator, card.ability.extra.denominator, 'baby_face') then
                card:juice_up()
                sendDebugMessage("Baby Face: Creating negative common joker")

                SMODS.add_card {
                    set = "Joker",
                    rarity = "Common",
                    edition = "e_negative",
                }

                return {
                    message = localize('sound_baby_face_spawn'),
                    card = card
                }
            end
        end
    end
}

local little_feet = {
    name = "little_feet",
    rarity = 3,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "golden_wind",
    blueprint_compat = true,
    config = { extra = { Xmult = 2 } },
    loc_vars = function(self, info_queue, center)
     return {
        vars = {center.ability.extra.Xmult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
   end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            local id = context.other_card:get_id()
            if id and id >= 2 and id <= 5 then
                sendDebugMessage("Little Feet: Scored card is rank: "..id..", so giving "..card.ability.extra.Xmult.."x mult")
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end,
    -- Handle when Little Feet specifically is added/removed from joker pool
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            sendDebugMessage("Little Feet: Added to deck, debuffing face cards")
            for k, v in pairs(G.playing_cards) do
                local rank = rank_string_from_id(v:get_id())
                if rank == "Jack" or rank == "Queen" or rank == "King" then
                    SMODS.debuff_card(v, true, card)
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        sendDebugMessage("Little Feet: Removed from deck, restoring face cards")
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, card)
        end
    end
}

local black_sabbath = {
    name = "black_sabbath",
    rarity = 1,
    cost = 6,
    jtype = "Stand",
    jclass = "Automatic",
    part = "golden_wind",
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false, -- Becomes perishable on scoring if enhanced, but not compatible with perish on creation
    config = { extra = { curr_chips = 40, curr_mult = 10, enhanced_chips = 200, enhanced_mult = 50 } }, -- x5 for both, but split to separate vars for easier balancing
    loc_vars = function(self, info_queue, center)
     return {
        vars = {center.ability.extra.curr_chips, center.ability.extra.curr_mult, center.ability.extra.enhanced_chips, center.ability.extra.enhanced_mult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
   end,
    calculate = function(self, card, context)
        -- Give chips and mult on scoring.
        -- If score catches fire, enhnance the chips and mult but become perishable
        if context.cardarea == G.jokers and context.scoring_hand then
            if G.GAME.chips then
                G.GAME._chips_before_hand = G.GAME.chips
            end

            if context.joker_main then
                return {
                    message = localize("sound_ho_ho_ho"),
                    colour = G.C.BLACK,
                    chip_mod = card.ability.extra.curr_chips,
                    mult_mod = card.ability.extra.curr_mult,
                    card = card
                }
            end
        end

        -- If score catches fire, make Black Sabbath perishable and enhance it's chips and mult.
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if not G.GAME.chips or not G.GAME.blind.chips then return end
            local start = G.GAME._chips_before_hand or 0 -- fallback if missing
            local hand_score = (G.GAME.chips or 0) - start

            sendDebugMessage("Black Sabbath: Hand scored with "..hand_score.." chips, threshold to hit is "..G.GAME.blind.chips)
            if hand_score > G.GAME.blind.chips and not card.ability.perishable then
                card.ability.extra.curr_chips = card.ability.extra.enhanced_chips
                card.ability.extra.curr_mult = card.ability.extra.enhanced_mult
                card.ability.perishable = true
                card.ability.perish_tally = G.GAME.perishable_rounds
                sendDebugMessage("Black Sabbath: Score caught fire, increasing chips to "..card.ability.extra.curr_chips.." and mult to "..card.ability.extra.curr_mult)

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

local rolling_stones = {
    name = "rolling_stones",
    rarity = 1,
    cost = 6,
    jtype = "Stand",
    jclass = "Automatic",
    part = "golden_wind",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { XMult = 2 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.XMult }}
    end,
    calculate = function(self, card, context)
        -- Sets all probabilities to 0
        if context.fix_probability then
            return {
                numerator = 0
            }
        end

        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.XMult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.XMult
                }
            end
        end
    end
}

return {
    name = "Golden Wind Stand Jokers",
    list = { sex_pistols, grateful_dead, spice_girl, sticky_fingers, gold_experience, gold_experience_requiem, king_crimson, moody_blues, baby_face, little_feet, black_sabbath, rolling_stones },
}