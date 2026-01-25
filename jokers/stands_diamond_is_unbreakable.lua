-- Diamond is Unbreakable stands

local red_hot_chili_pepper = {
    name = "red_hot_chili_pepper",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 1, money_mod = 1, mult = 0 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.mult_mod, card.ability.extra.money_mod, card.ability.extra.mult }}
    end,
    calculate = function(self, card, context)
        if G.GAME and G.GAME.dollars > 0 and card.ability then
            card.ability.extra.mult = G.GAME.dollars * card.ability.extra.mult_mod -- In case we scale this differently later
        end

        -- Gives mult per $ held
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Red Hot Chili Peppers: Giviing "..card.ability.extra.mult.." mult based on current money.")
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}

return {
    name = "Diamond is Unbreakable Stand Jokers",
    list = { red_hot_chili_pepper },
}