-- Golden Wind stands

local sex_pistols = {
    name = "sex_pistols",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Long Range",
    part = "golden_wind",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 0, chosen_rank = "undecided", deactivated = false } }, -- Default for displayed strings in desc
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.mult, card.ability.extra.chosen_rank}}
    end,
    calculate = function(self, card, context)
        -- When blind is starting, choose a random rank
        local rank_options = {"Ace", "2", "3", "5", "6", "7"}
        if context.setting_blind then
            local chosenRank = rank_options[math.random(#rank_options)]
            card.ability.extra.chosen_rank = chosenRank
            sendDebugMessage("Sex Pistols: Chose rank "..chosenRank)
        end

        -- When a hand is scored, if rank is present in scoring hand then boost joker mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                if not context.blueprint then
                    for k, v in pairs(context.scoring_hand) do
                        local rank = v:get_id()
                        if not v.debuff and tostring(rank) == card.ability.extra.chosen_rank or rank == 14 and card.ability.extra.chosen_rank == "Ace" then
                            if not card.ability.extra.deactivated then
                                sendDebugMessage("Sex Pistols: Found match rank for "..card.ability.extra.chosen_rank)
                                if card.ability.extra.chosen_rank == "Ace" then
                                    card.ability.extra.mult = card.ability.extra.mult + 1
                                else
                                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.chosen_rank
                                end
                                card.ability.extra.deactivated = true
                            end
                        end
                    end
                end

                if card.ability.extra.mult > 0 then
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                        colour = G.C.MULT,
                        mult_mod = card.ability.extra.mult
                    }
                else
                    return {
                        message = localize("sound_mista")
                    }
                end
            end
        end

        -- When blind ends, reset display strings
        if context.end_of_round then
            card.ability.extra.chosen_rank = localize("undecided")
            card.ability.extra.deactivated = false
        end
    end
}

return {
    name = "Golden Wind Stand Jokers",
    list = { sex_pistols },
}