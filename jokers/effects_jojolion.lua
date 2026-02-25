-- Jojolion Effects

local higashikata_house = {
    name = "higashikata_house",
    rarity = 1,
    cost = 5,
    jtype = "Effect",
    part = "jojolion",
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
                sendDebugMessage("Higashikata House: Giving "..card.ability.extra.chips.." chips for Full House")
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
                    sendDebugMessage("Higashikata Fruit Parlor: Giving "..card.ability.extra.pair_money.." money for Pair")
                    ease_dollars(card.ability.extra.pair_money)
                    money_given = card.ability.extra.pair_money
                elseif context.scoring_name == "Two Pair" then
                    sendDebugMessage("Higashikata Fruit Parlor: Giving "..card.ability.extra.two_pair_money.." money for Two Pair")
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

return {
    name = "Jojolion Effects Jokers",
    list = { higashikata_house, higashikata_fruit_parlor },
}