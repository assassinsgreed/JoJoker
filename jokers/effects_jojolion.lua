-- Jojolion Effects

local higashikata_house = {
    name = "higashikata_house",
    rarity = 1,
    cost = 5,
    jtype = "Effect",
    part = "jojolion",
    themes = { core = { jojoker.themes.TWO_PAIR_FULL_HOUSE } },
    similar = { jojoker.similar.HAND_TYPE_CHIPS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 80 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand and context.scoring_name == "Full House" then
            if context.joker_main then
                jojoker.debug("Higashikata House: Giving "..card.ability.extra.chips.." chips for Full House")
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour=G.C.CHIPS,
                    chip_mod=card.ability.extra.chips,
                }
            end
        end
    end
}

local higashikata_fruit_parlor = {
    name = "higashikata_fruit_parlor",
    rarity = 2,
    cost = 5,
    jtype = "Effect",
    part = "jojolion",
    themes = { core = { jojoker.themes.PAIRS, jojoker.themes.TWO_PAIR_FULL_HOUSE }, support = { jojoker.themes.MONEY_HELD } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { pair_money = 2, two_pair_money = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.pair_money, center.ability.extra.two_pair_money }}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                local money_given = 0
                if context.scoring_name == "Pair" then
                    jojoker.debug("Higashikata Fruit Parlor: Giving "..card.ability.extra.pair_money.." money for Pair")
                    ease_dollars(card.ability.extra.pair_money)
                    money_given = card.ability.extra.pair_money
                elseif context.scoring_name == "Two Pair" then
                    jojoker.debug("Higashikata Fruit Parlor: Giving "..card.ability.extra.two_pair_money.." money for Two Pair")
                    ease_dollars(card.ability.extra.two_pair_money)
                    money_given = card.ability.extra.two_pair_money
                end

                if money_given > 0 then
                    return {
                        message = localize('$')..money_given,
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end
}

local wall_eyes = {
    name = "wall_eyes",
    rarity = 2,
    cost = 6,
    jtype = "Effect",
    part = "jojolion",
    themes = { support = { jojoker.themes.STONE_CARDS } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 20, dollars = 1 } },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return {
            vars = { center.ability.extra.chips, center.ability.extra.dollars, get_wall_eyes_chips(center) }
        }
    end,
    calculate = function(self, card, context)
        -- Gives chips for stone cards in deck during scoring
        if context.joker_main then
            local chips_given = get_wall_eyes_chips(card)
            if chips_given > 0 then
                jojoker.debug("Wall Eyes: Giving "..chips_given.." chips for "..count_stone_cards().." stone cards in deck")
                return {
                    message = localize{type='variable', key='a_chips', vars={chips_given}},
                    colour = G.C.CHIPS,
                    chip_mod = chips_given,
                }
            end
        end

        -- Gives money for stone cards held in hand at the end of the round
        if context.end_of_round and context.individual and context.cardarea == G.hand
            and SMODS.has_enhancement(context.other_card, 'm_stone') then
            jojoker.debug("Wall Eyes: Giving $"..card.ability.extra.dollars.." for a held stone card")
            return {
                dollars = card.ability.extra.dollars,
            }
        end
    end
}

return {
    name = "Jojolion Effects Jokers",
    list = { higashikata_house, higashikata_fruit_parlor, wall_eyes },
}