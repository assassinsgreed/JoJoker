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
      return {vars = {card.ability.extra.mult, card.ability.extra.chosen_rank}}
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
      return {vars = {card.ability.extra.starting_mult, card.ability.extra.mult_decay, card.ability.extra.mult}}
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
      return {vars = {card.ability.extra.chips_mod, card.ability.extra.Xmult_mod, card.ability.extra.chips, card.ability.extra.Xmult}}
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
      return {vars = {}}
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
      return {vars = { center.ability.extra.numerator, center.ability.extra.denominator }}
    end,
    calculate = function(self, card, context)
        -- For each scored queen, card, potentially make it polychrome if it doesn't have an edition
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

return {
    name = "Golden Wind Stand Jokers",
    list = { sex_pistols, grateful_dead, spice_girl, sticky_fingers, gold_experience, gold_experience_requiem },
}