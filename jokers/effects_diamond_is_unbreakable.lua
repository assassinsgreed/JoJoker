-- Diamond is Unbreakable effects

local voice_of_love = {
    name = "voice_of_love",
    rarity = 1,
    cost = 5,
    jtype = "Effect",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        -- Each heart gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") then
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


return {
    name = "Diamond is Unbreakable Effect Jokers",
    list = { voice_of_love },
}