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

return {
    name = "Steel Ball Run Effects Jokers",
    list = { the_fifth_lesson, turbo_eyes, the_true_mans_world },
}