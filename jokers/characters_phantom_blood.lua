-- Phantom Blood effects

local danny = {
    name = "danny",
    rarity = 2,
    cost = 5,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 15 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- During scoring, give 15 mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if G.GAME.chips then
                G.GAME._chips_before_hand = G.GAME.chips
            end
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.mult
                }
            end
        end

        -- If score catches fire, then destroy Danny
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if not G.GAME.chips or not G.GAME.blind.chips then return end
            local start = G.GAME._chips_before_hand or 0 -- fallback if missing
            local hand_score = (G.GAME.chips or 0) - start
            sendDebugMessage("Danny: Recognized score at hand start as "..start)
            sendDebugMessage("Danny: Resulting chips are "..hand_score.." and blind chips are "..G.GAME.blind.chips..". Will "..(hand_score > G.GAME.blind.chips and "" or " not ").." be destroyed.")
            if hand_score > G.GAME.blind.chips then
                -- Destroy Danny        
                G.E_MANAGER:add_event(Event({
                  func = function()
                    remove(self, card, context, true)
                    return true
                  end
                }))
                G.GAME._chips_before_hand = nil

                return {
                    message = localize("sound_yip")
                }
            end
        end
    end
}

local baron_zeppeli = {
    name = "baron_zeppeli",
    rarity = 3,
    cost = 8,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { } },
    loc_vars = function(self, info_queue, center)
      return {vars = { }}
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            local currentChips = hand_chips or 0
            hand_chips = math.floor(currentChips / 2)
            local addedMult = math.floor(currentChips * 0.2)
            mult = mult + addedMult
            sendDebugMessage("Baron Zeppeli: Cut chips to "..hand_chips.." and added "..addedMult.." to mult, new mult is "..(mult))

            return {
                message = localize("sound_hey_baby"),
                colour = G.C.GOLD,
            }
        end
    end
}

local speedwagon = {
    name = "speedwagon",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_mod }}
    end,
    calculate = function(self, card, context)
        if context.pre_discard then
            ease_dollars(card.ability.extra.money_mod)
            sendDebugMessage("Speedwagon: Gave $"..card.ability.extra.money_mod.." for used discard.")

            return {
                message = localize('$').."$",
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

local zombies = {
    name = "zombies",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult_per = 2, current_mult = 2, numerator = 1, denominator = 4, } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.mult_per, center.ability.extra.current_mult, center.ability.extra.numerator, center.ability.extra.denominator }}
    end,
    calculate = function(self, card, context)
        -- On scoring, give mult_per mult for each held joker and calculate (in the event of special jokers)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Zombies: Giving mult of "..card.ability.extra.current_mult.." for count of held zombie jokers.")
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current_mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.current_mult
                }
            end
        end

        -- Potentially duplicate joker at end of small/big blind
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if #G.jokers.cards < G.jokers.config.card_limit then
                sendDebugMessage("Zombies: "..#G.jokers.cards.." jokers in play, below limit of "..G.jokers.config.card_limit..", considering replicating.")
                if SMODS.pseudorandom_probability(card, 'zombies', card.ability.extra.numerator, card.ability.extra.denominator, 'zombies') then
                    sendDebugMessage("Zombies: Replicated!")
                    
                    play_sound('tarot1')
                    local new_card = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_jojoker_zombies", no_edition = true})
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)

                    return {
                        message = localize("sound_grr")
                    }
                end
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            card.ability.extra.current_mult = card.ability.extra.mult_per ^ get_joker_count("zombies")
        end
    end
}

local straizo = {
    name = "straizo",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "phantom_blood",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_straight = 80, chips_straight_flush = 200 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips_straight, center.ability.extra.chips_straight_flush }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            local hand_chips_map = {
                ["Straight"] = card.ability.extra.chips_straight,
                ["Straight Flush"] = card.ability.extra.chips_straight_flush
            }
            
            if context.joker_main then
                local chips = hand_chips_map[context.scoring_name]
                if chips then
                    sendDebugMessage("Straizo: Giving "..chips.." chips for "..context.scoring_name)
                    return {
                        message = localize{type='variable', key='a_chips', vars={chips}},
                        colour=G.C.CHIPS,
                        chip_mod=chips,
                    }
                end
            end
        end
    end
}

return {
    name = "Phantom Blood Effect Jokers",
    list = { danny, baron_zeppeli, speedwagon, zombies, straizo },
}