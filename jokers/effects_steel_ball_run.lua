-- Steel Ball Run Effects

local the_fifth_lesson = {
    name = "the_fifth_lesson",
    rarity = 2,
    cost = 5,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_shortcut', config = {} }
        return {vars = {}}
    end
}

local turbo_eyes = {
    name = "turbo_eyes",
    rarity = 1,
    cost = 4,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { cards = 2 } },
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
                sendDebugMessage("Turbo Eyes is giving " .. chips .. " chips based on scanned cards")
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

local the_true_mans_world = {
    name = "the_true_mans_world",
    rarity = 2,
    cost = 5,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.25, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        -- If playing a hand, increase XMult by 0.25
        if context.before and context.scoring_hand then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            sendDebugMessage("The True Man's World: Increasing Xmult by " .. card.ability.extra.Xmult_mod .. " to " .. card.ability.extra.Xmult.." before playing hand")
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.GOLD
            }
        end

        -- Reset XMult on discard
        if context.pre_discard then
            card.ability.extra.Xmult = 1
            sendDebugMessage("The True Man's World: Resetting Xmult to 1 on discard")
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end

        -- Give Xmult on hand scoring
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

local the_first_napkin = {
    name = "the_first_napkin",
    rarity = 3,
    cost = 7,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { has_triggered = false } },
    calculate = function(self, card, context)
        -- If first hand is played, all cards gain chips == highest rank played
        if context.before and context.scoring_hand and not card.ability.extra.has_triggered then
            card.ability.extra.has_triggered = true

            -- Find highest rank
            local highest_rank = 0
            for i, c in ipairs(context.full_hand) do
                if c:get_id() > highest_rank then
                    highest_rank = c:get_id()
                end
            end

            sendDebugMessage("The First Napkin: Giving all played cards +"..highest_rank.." chips before playing hand")
            for _, c in ipairs(context.full_hand) do
                c.ability.perma_bonus = (c.ability.perma_bonus or 0) + highest_rank
            end
            return {
                message = localize('sound_left_napkin'),
                colour = G.C.GOLD
            }
        end

        -- If first hand is discarded, all hands gain mult == lowest rank discarded
        if context.pre_discard and not card.ability.extra.has_triggered then
            card.ability.extra.has_triggered = true

            -- Copy so sorting doesn't change the original hand order
            local lowest_rank = 14
            for i, c in ipairs(context.full_hand) do
                if c:get_id() < lowest_rank then
                    lowest_rank = c:get_id()
                end
            end

            sendDebugMessage("The First Napkin: Giving all played cards +"..lowest_rank.." mult before playing hand")
            for _, c in ipairs(context.full_hand) do
                c.ability.perma_mult = (c.ability.perma_mult or 0) + lowest_rank
            end
            return {
                message = localize('sound_right_napkin'),
                colour = G.C.GOLD
            }
        end

        -- When blind ends, reset has_triggered
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.has_triggered = false
        end
    end
}

local wavering_heart = {
    name = "wavering_heart",
    rarity = 1,
    cost = 4,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chip_mod = 8, mult_mod = 3, curr_chips = 0, curr_mult = 0 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.chip_mod, card.ability.extra.mult_mod, card.ability.extra.curr_chips, card.ability.extra.curr_mult}}
    end,
    calculate = function(self, card, context)
        -- During scoring, give chips and mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize('sound_do_not_shoot'),
                    chip_mod = card.ability.extra.curr_chips,
                    mult_mod = card.ability.extra.curr_mult,
                }
            end
        end

        -- When rerolling the shop, increase chip_mod and mult_mod
        if context.reroll_shop then
            card.ability.extra.curr_chips = card.ability.extra.curr_chips + card.ability.extra.chip_mod
            card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.mult_mod
            sendDebugMessage("Wavering Heart: Increasing chip_mod to " .. card.ability.extra.curr_chips .. " and mult_mod to " .. card.ability.extra.curr_mult .. " on shop reroll")
             return {
                message = localize('k_upgrade_ex'),
                colour = G.C.GOLD
            }
        end
    end
}

local dark_determination = {
    name = "dark_determination",
    rarity = 3,
    cost = 6,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult = 1, Xmult_mod = 1, has_rerolled = false } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        -- During scoring, give Xmult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                card.ability.extra.has_rerolled = false
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end

        -- When rerolling the shop, mark joker as not upgradable
        if context.reroll_shop then
            sendDebugMessage("Dark Determination: Rerolled in shop, preventing Xmult increase")
            card.ability.extra.has_rerolled = true
        end

        if context.ending_shop then
            if not card.ability.extra.has_rerolled then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                sendDebugMessage("Dark Determination: Increasing Xmult to " .. card.ability.extra.Xmult .. " on shop ending without reroll")
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

local left_side_ataxia = {
    name = "left_side_ataxia",
    rarity = 3,
    cost = 7,
    jtype = "Effect",
    part = "steel_ball_run",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_per_joker = 100, current_chips = 0 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.chips_per_joker, card.ability.extra.current_chips}}
    end,
    calculate = function(self, card, context)
        -- During scoring, give chips per disabled joker
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.current_chips}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.current_chips,
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            local disabled = handle_left_side_ataxia_disabling(card)
            card.ability.extra.current_chips = disabled * card.ability.extra.chips_per_joker
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local disabled = handle_left_side_ataxia_disabling(card)
        card.ability.extra.current_chips = disabled * card.ability.extra.chips_per_joker
    end,
    remove_from_deck = function(self, card, from_debuff)
        for i = 1, #G.jokers.cards do
            local other_joker = G.jokers.cards[i]
            other_joker.ability.extra.lta_disabled = false
            other_joker.ability.debuff_sources[tostring(card)] = false
            SMODS.recalc_debuff(other_joker)
        end
    end
}

return {
    name = "Steel Ball Run Effects Jokers",
    list = { the_fifth_lesson, turbo_eyes, the_true_mans_world, the_first_napkin, wavering_heart, dark_determination, left_side_ataxia },
}