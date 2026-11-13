-- Stardust Crusaders Effects

local joestar_birthmark = {
    name = "joestar_birthmark",
    rarity = 2,
    cost = 8,
    jtype = "Effect",
    part = "stardust_crusaders",
    themes = { support = { jojoker.themes.SCORE_EVERY_CARD, jojoker.themes.PERMANENT_BUFF_EATER } },
    similar = { jojoker.similar.PERMANENT_CARD_BUFFS },
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
                jojoker.debug("Joestar Birthmark: Increasing additional chips and mult of scored card to "..tostring(context.other_card.ability.perma_bonus).." and "..tostring(context.other_card.ability.perma_mult))

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

local hat_hair = {
    name = "hat_hair",
    rarity = 1,
    cost = 4,
    jtype = "Effect",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 50, mult = 5 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.chips, center.ability.extra.mult }}
    end,
    calculate = function(self, card, context)
        -- Randomly giveds chips or mult when scoring a hand
        if context.joker_main then
            if pseudorandom('hat_hair') < 0.5 then
                jojoker.debug("Hat Hair: Giving "..tostring(card.ability.extra.chips).." chips")
                return {
                    message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                }
            else
                jojoker.debug("Hat Hair: Giving "..tostring(card.ability.extra.mult).." mult")
                return {
                    message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult,
                }
            end
        end
    end
}

local speedwagon_foundation_submarine = {
    name = "speedwagon_foundation_submarine",
    rarity = 1,
    cost = 3,
    jtype = "Effect",
    part = "stardust_crusaders",
    themes = { core = { jojoker.themes.SKIPPING_BLINDS } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money = 3 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.money }}
    end,
    calculate = function(self, card, context)
        -- Give money and enter the shop when skipping a blind
        if context.skip_blind then
            -- Copies only pay out; one shop per skip
            if not context.blueprint then
                jojoker_open_shop_after_skip()
            end
            ease_dollars(card.ability.extra.money)
            jojoker.debug("Speedwagon Foundation Submarine: Gave $"..card.ability.extra.money.." for skipping a blind.")

            return {
                message = localize('$')..card.ability.extra.money,
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

local toilet_pig = {
    name = "toilet_pig",
    rarity = 2,
    cost = 6,
    jtype = "Effect",
    part = "stardust_crusaders",
    themes = { core = { jojoker.themes.DISCARDS } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { cards = 25, remaining = 25, tags_due = 0 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.cards, center.ability.extra.remaining }}
    end,
    calculate = function(self, card, context)
        -- Gives a random tag for every 20 cards discarded
        -- Count the whole discard up front so copies know the payout regardless of joker order
        if context.pre_discard and not context.blueprint then
            card.ability.extra.tags_due = 0
            card.ability.extra.remaining = card.ability.extra.remaining - #context.full_hand
            while card.ability.extra.remaining <= 0 do
                card.ability.extra.remaining = card.ability.extra.remaining + card.ability.extra.cards
                card.ability.extra.tags_due = card.ability.extra.tags_due + 1
            end
        end

        if context.discard and card.ability.extra.tags_due > 0
            and context.other_card == context.full_hand[#context.full_hand] then
            for _ = 1, card.ability.extra.tags_due do
                jojoker_add_random_tag('jojoker_toilet_pig')
            end
            jojoker.debug("Toilet Pig: Gave "..card.ability.extra.tags_due.." random tag(s) for discarded cards.")

            return {
                message = localize('k_plus_tag'),
                colour = G.C.FILTER,
            }
        end
    end
}

return {
    name = "Stardust Crusaders Effect Jokers",
    list = { joestar_birthmark, hat_hair, speedwagon_foundation_submarine, toilet_pig },
}