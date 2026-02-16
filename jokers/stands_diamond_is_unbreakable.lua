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
    config = { extra = { mult_mod = 0.5, money_mod = 1, mult = 0 } },
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

local the_hand = {
    name = "the_hand",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 8, debuff_rank = 3, buffed_rank_one = 2, buffed_rank_two = 4 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.mult_mod, card.ability.extra.debuff_rank, card.ability.extra.buffed_rank_one, card.ability.extra.buffed_rank_two }}
    end,
    calculate = function(self, card, context)
        local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}

        -- At the start of round, pick a random rank. Debuff it and buff the rank on either side
        if context.setting_blind then
            local debuff_index = math.random(1, #ranks);
            card.ability.extra.debuff_rank = ranks[debuff_index]
            local low_rank = ranks[debuff_index - 1 >= 1 and debuff_index - 1 or #ranks]
            local high_rank = ranks[debuff_index + 1 <= #ranks and debuff_index + 1 or 1]
            card.ability.extra.buffed_rank_one = low_rank
            card.ability.extra.buffed_rank_two = high_rank

            sendDebugMessage("The Hand: Debuffed rank "..card.ability.extra.debuff_rank..", buffed ranks "..low_rank.." and "..high_rank)

            -- Debuff all cards of the debuffed rank
            for k, v in pairs(G.playing_cards) do
                if rank_string_from_id(v:get_id()) == card.ability.extra.debuff_rank then
                    SMODS.debuff_card(v, true, card)
                end
            end
        end
        
        -- During scoring, give mult per scored card that is buffed rank
        if context.individual and context.cardarea == G.play then
            for i = 1, #context.scoring_hand do
                local scored_card = context.scoring_hand[i]
                local scored_rank = rank_string_from_id(scored_card:get_id())
                if scored_rank == card.ability.extra.buffed_rank_one or scored_rank == card.ability.extra.buffed_rank_two then
                    sendDebugMessage("The Hand: Found buffed rank "..scored_rank.." in scored hand, giving +"..card.ability.extra.mult_mod.." mult.")
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod}},
                        colour = G.C.MULT,
                        mult_mod = card.ability.extra.mult_mod
                    }
                end
            end
        end

        -- Restore debuffed ranks at the end of the round
        if context.end_of_round and not context.individual and not context.repetition then
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, card)
            end
        end
    end
}

local superfly = {
    name = "superfly",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Automatic",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { } },
    calculate = function(self, card, context)
        -- When sold, disables active boss blind
        if context.selling_self and not context.blueprint then
            if G.GAME.blind and G.GAME.blind:get_type() == 'Boss' then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                G.GAME.blind:disable()
            end
        end
    end
}

return {
    name = "Diamond is Unbreakable Stand Jokers",
    list = { red_hot_chili_pepper, the_hand, superfly },
}