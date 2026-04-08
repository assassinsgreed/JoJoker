-- Phantom Blood Effects

local sword_of_luck_and_pluck = {
    name = "sword_of_luck_and_pluck",
    rarity = 3,
    cost = 5,
    jtype = "Effect",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { trigger_rate = 3 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.trigger_rate }}
    end,
    calculate = function(self, card, context)
        -- Lucky cards have a 3x chance of triggering
        if context.fix_probability then
            if context.identifier == 'lucky_mult' or context.identifier == 'lucky_money' then
                return {
                    denominator = math.ceil(context.denominator / 3),
                }
            end
        end
    end
}

local thunder_cross_split_attack = {
    name = "thunder_cross_split_attack",
    rarity = 3,
    cost = 7,
    jtype = "Effect",
    part = "phantom_blood",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_loss = 1, Xmult_gain = 0.2, Xmult = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.money_loss, center.ability.extra.Xmult_gain, center.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            if G.GAME.dollars > 0 then
                sendDebugMessage("Thunder Cross Split Attack: Removing money and giving Xmult")
                G.GAME.dollars = G.GAME.dollars - card.ability.extra.money_loss
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            end

            return {
                message = localize('sound_fell_for_it'),
                colour = G.C.GOLD
            }
        end

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
    name = "Phantom Blood Effect Jokers",
    list = { sword_of_luck_and_pluck, thunder_cross_split_attack },
}