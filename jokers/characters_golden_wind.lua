-- Golden Wind characters

local leaky_eye_luca = {
    name = "leaky_eye_luca",
    rarity = 1,
    cost = 5,
    jtype = "Character",
    part = "golden_wind",
    themes = { core = { jojoker.themes.SPADES } },
    similar = { jojoker.similar.SUIT_MULT },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- Each spade gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Spades") then
                if context.other_card.debuff then
                    return {
                        message = localize("k_debuffed"),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                end
            end
        end
    end
}

local mista = {
    name = "mista",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { fours_hand_chips = 400, fours_hand_mult = 40, hand_chips = 200, hand_mult = 20, card_chips = 40, card_mult = 4 } },
    loc_vars = function(self, info_queue, center)
      local extra = center.ability.extra
      return {vars = {extra.card_chips, extra.card_mult, extra.hand_chips, extra.hand_mult, extra.fours_hand_chips, extra.fours_hand_mult}}
    end,
    calculate = function(self, card, context)
        -- Four of a Kind pays its flat bonus instead, so four 4s don't also pay per card
        if context.individual and context.cardarea == G.play and context.scoring_name ~= "Four of a Kind"
          and context.other_card:get_id() == 4 and not context.other_card.debuff then
            return {
                chips = card.ability.extra.card_chips,
                mult = card.ability.extra.card_mult,
                card = card
            }
        end

        if context.joker_main and context.scoring_name == "Four of a Kind" then
            local of_fours = is_four_of_a_kind_of_fours(context.poker_hands)
            return {
                chips = of_fours and card.ability.extra.fours_hand_chips or card.ability.extra.hand_chips,
                mult = of_fours and card.ability.extra.fours_hand_mult or card.ability.extra.hand_mult,
            }
        end

        -- Debuffs only once the hand is done, so every scored 4 pays out first
        if context.after and not context.blueprint then
            local triggered = context.scoring_name == "Four of a Kind"
            for _, v in ipairs(context.scoring_hand) do
                if v:get_id() == 4 and not v.debuff then triggered = true end
            end
            if triggered then
                sendDebugMessage("Mista: Unlucky 4, debuffed until end of round")
                SMODS.debuff_card(card, true, 'jojoker_mista')
                return {
                    message = localize("k_debuffed"),
                    colour = G.C.RED,
                }
            end
        end
    end
}


return {
    name = "Golden Wind Character Jokers",
    list = { leaky_eye_luca, mista },
}