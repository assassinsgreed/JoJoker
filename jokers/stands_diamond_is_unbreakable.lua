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
      return {
        vars = { card.ability.extra.mult_mod, card.ability.extra.money_mod, card.ability.extra.mult },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
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
            local scored_rank = rank_string_from_id(context.other_card:get_id())
            if scored_rank == card.ability.extra.buffed_rank_one or scored_rank == card.ability.extra.buffed_rank_two then
                sendDebugMessage("The Hand: Found buffed rank "..scored_rank.." in scored hand, giving +"..card.ability.extra.mult_mod.." mult.")
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.mult_mod
                }
            end
        end

        -- Restore debuffed ranks at the end of the round
        if context.end_of_round and not context.individual and not context.repetition then
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, card)
            end
        end
    end,
    -- Handle card debuffing on add/remove (via Judgment)
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
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
    end,
    remove_from_deck = function(self, card, from_debuff)
        sendDebugMessage("The Hand: Removed from deck, restoring face cards")
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, card)
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

local crazy_diamond = {
    name = "crazy_diamond",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.mult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Each diamond gives +4 mult
        if context.individual and not context.end_of_round and context.cardarea == G.play then
            if context.other_card:is_suit("Diamonds") then
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

local bad_company = {
    name = "bad_company",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.mult, G.GAME.starting_deck_size},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Each card above 52 gives +5 mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and #G.playing_cards > G.GAME.starting_deck_size then
                local mult_given = card.ability.extra.mult * (#G.playing_cards - G.GAME.starting_deck_size)
                sendDebugMessage("Bad Company: Giviing "..mult_given.." mult based on current deck size of "..#G.playing_cards..".")
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {mult_given}},
                    colour = G.C.MULT,
                    mult_mod = mult_given
                }
            end
        end
    end
}

local cheap_trick = {
    name = "cheap_trick",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Automatic",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 2, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- When a joker is destroyed, increase XMult
        if context.joker_type_destroyed and context.card ~= card then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            sendDebugMessage("Cheap Trick: A joker was destroyed, increasing XMult to "..card.ability.extra.Xmult)
        end

        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Cheap Trick: Giving XMult of "..card.ability.extra.Xmult)
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local cinderella = {
    name = "cinderella",
    rarity = 1,
    cost = 4,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { is_disabled = false } },
    loc_vars = function(self, info_queue, card)
      return {
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- When scoring first hand, change first card to queen/king if it isn't already either suit
        if context.final_scoring_step and not context.blueprint and not card.ability.extra.is_disabled then
            card.ability.extra.is_disabled = true -- Disable to prevent multiple activations in the same round
            local first_card = context.scoring_hand[1]
            local first_card_rank = first_card:get_id()
            if not first_card.debuff and first_card_rank ~= 12 and first_card_rank ~= 13 then
                local new_rank = math.random(12, 13)
                sendDebugMessage("Cinderella: Changing first card rank from "..rank_string_from_id(first_card_rank).." to "..rank_string_from_id(new_rank))

                local suit_to_prefix = { Spades = 'S', Hearts = 'H', Clubs = 'C', Diamonds = 'D' }
                local suit_prefix = suit_to_prefix[first_card.base.suit]

                -- Trigger event to convert the first_card_rank card to either a Queen or King
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0,
                    func = function()
                        first_card:set_base(G.P_CARDS[suit_prefix..'_'..(new_rank == 12 and 'Q' or 'K')])
                        first_card:juice_up()
                        return true
                    end
                }))

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD,
                    card = first_card
                }
            end
        end

        -- When round ends, reset activation
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.is_disabled = false
        end
    end
}

local atom_heart_father = {
    name = "atom_heart_father",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                sendDebugMessage("Atom Heart Father: Giving XMult of "..card.ability.extra.Xmult)
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local seals_in_deck = 0
            for k, v in pairs(G.playing_cards) do
                if v.seal then
                    seals_in_deck = seals_in_deck + 1
                end
            end
            card.ability.extra.Xmult = 1 + seals_in_deck * card.ability.extra.Xmult_mod
        end
    end
}

local surface = {
    name = "surface",
    rarity = 3,
    cost = 10,
    jtype = "Stand",
    jclass = "Automatic",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
      return {
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
       -- Copies leftmost joker, if possible
 		local other_joker = G.jokers.cards[1]
 		local other_joker_ret = SMODS.blueprint_effect(card, other_joker, context)
 		if other_joker_ret then
 			return other_joker_ret
 		end
    end
}

local killer_queen = {
    name = "killer_queen",
    rarity = 4,
    cost = 10,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { numerator = 1, denominator = 3 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.numerator, card.ability.extra.denominator },
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end,
    calculate = function(self, card, context)
        -- When beating a boss, has a chance to rewind the blind
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not card.debuff then
            if SMODS.pseudorandom_probability(card, 'killer_queen', card.ability.extra.numerator, card.ability.extra.denominator, 'killer_queen') then
                sendDebugMessage("Killer Queen: Rewinding blind after beating boss")
                card:juice_up(0.1)
                ease_ante(-1)

                return {
                    message = localize('sound_bites_the_dust'),
                    colour = G.C.GOLD
                }
            end
        end
    end
}

local heavens_door = {
    name = "heavens_door",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    jclass = "Close Range",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        -- When beating a boss, gives a random tag
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not card.debuff then
            sendDebugMessage("Heaven's Door: Giving random tag after beating boss")
            card:juice_up(0.1)
            local tag_pool = get_current_pool('Tag')
            local selected_tag = pseudorandom_element(tag_pool, 'jojoker')
            local it = 1
            while selected_tag == 'UNAVAILABLE' do
                it = it + 1
                selected_tag = pseudorandom_element(tag_pool, 'jojoker_seed_resample'..it)
            end
            add_tag(Tag(selected_tag, false, 'Small'))

            return {
                message = localize('sound_rewriting'),
                colour = G.C.GOLD
            }
        end
    end
}

local the_lock = {
    name = "the_lock",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    jclass = "Automatic",
    part = "diamond_is_unbreakable",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_gain = 5, curr_mult = 0, most_played = "High Card" } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult_gain, card.ability.extra.curr_mult, card.ability.extra.most_played } }
    end,
    calculate = function(self, card, context)
        -- When playing a hand, increase mult if it's the most played hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                sendDebugMessage("The Lock: Hand played is "..context.scoring_name..", most played hand is "..card.ability.extra.most_played)
                if get_most_played_hand_info().count == 1 or context.scoring_name == card.ability.extra.most_played then
                    sendDebugMessage("The Lock: Gaining mult for most played hand")
                    card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.mult_gain
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                else
                    sendDebugMessage("The Lock: Resetting mult for non-most played hand")
                    card.ability.extra.curr_mult = 0
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
            end

            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.curr_mult}},
                    colour = G.C.MULT,
                    mult_mod = card.ability.extra.curr_mult
                }
            end
        end
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.most_played = get_most_played_hand_info().name
        end
    end
}

return {
    name = "Diamond is Unbreakable Stand Jokers",
    list = { red_hot_chili_pepper, the_hand, superfly, crazy_diamond, bad_company, cheap_trick, cinderella, atom_heart_father, surface, killer_queen, heavens_door, the_lock },
}