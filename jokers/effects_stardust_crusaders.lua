-- Stardust Crusaders Effects

local joestar_birthmark = {
    name = "joestar_birthmark",
    rarity = 3,
    cost = 8,
    jtype = "Effect",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {chips = 5, mult = 1} },
    loc_vars = function(self, info_queue, center)
      return {vars = { center.ability.extra.chips, center.ability.extra.mult }}
    end,
    calculate = function(self, card, context)
        -- Permanently gives +5 chips and +1 mult to each scored card
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card.debuff then
                return {
                    message = localize("k_debuffed"),
                    colour = G.C.RED,
                    card = card,
                }
            else
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
                context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult
                context.other_card:juice_up()
                sendDebugMessage("Joestar Birthmark: Increasing additional chips and mult of scored card to "..tostring(context.other_card.ability.perma_bonus).." and "..tostring(context.other_card.ability.perma_mult))

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

return {
    name = "Stardust Crusaders Effect Jokers",
    list = { joestar_birthmark },
}