-- Diamond is Unbreakable stands

local red_hot_chili_pepper = {
    name = "red_hot_chili_pepper",
    rarity = 2,
    cost = 5,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.MONEY_HELD } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_mod = 0.5, money_mod = 1, mult = 0 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = { card.ability.extra.mult_mod, card.ability.extra.money_mod, card.ability.extra.mult }
    }
    end,
    calculate = function(self, card, context)
        if G.GAME and card.ability then
            -- Recalculate even at $0 or in debt, so the mult doesn't go stale (or negative)
            card.ability.extra.mult = math.max(0, G.GAME.dollars) * card.ability.extra.mult_mod -- In case we scale this differently later
        end

        -- Gives mult per $ held
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                jojoker.debug("Red Hot Chili Peppers: Giviing "..card.ability.extra.mult.." mult based on current money.")
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
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.DEBUFFED_CARDS } },
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

            jojoker.debug("The Hand: Debuffed rank "..card.ability.extra.debuff_rank..", buffed ranks "..low_rank.." and "..high_rank)

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
                jojoker.debug("The Hand: Found buffed rank "..scored_rank.." in scored hand, giving +"..card.ability.extra.mult_mod.." mult.")
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

            jojoker.debug("The Hand: Debuffed rank "..card.ability.extra.debuff_rank..", buffed ranks "..low_rank.." and "..high_rank)

            -- Debuff all cards of the debuffed rank
            for k, v in pairs(G.playing_cards) do
                if rank_string_from_id(v:get_id()) == card.ability.extra.debuff_rank then
                    SMODS.debuff_card(v, true, card)
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- Must mirror the from_debuff check in add_to_deck, or a debuff cycle permanently restores the chosen rank
        if not from_debuff then
            jojoker.debug("The Hand: Removed from deck, restoring face cards")
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
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.SELLING_JOKERS } },
    similar = { jojoker.similar.BOSS_BLIND_DISABLERS },
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
    themes = { core = { jojoker.themes.DIAMONDS } },
    similar = { jojoker.similar.SUIT_MULT },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.mult}
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
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.DECK_GROWING } },
    conflicts = { caesar = "wants_a_bigger_deck", john_rod = "wants_a_bigger_deck" },
    similar = { jojoker.similar.DECK_SIZE_COUNTERS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, center)
      return {
        vars = {center.ability.extra.mult, G.GAME.starting_deck_size}
    }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local mult_given = get_bad_company_mult(card)
            if mult_given > 0 then
                jojoker.debug("Bad Company: Giving "..mult_given.." mult based on current deck size of "..#G.playing_cards..".")
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
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.JOKER_DESTRUCTION } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 1.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}
    }
    end,
    calculate = function(self, card, context)
        -- When a joker is destroyed, increase XMult
        if context.joker_type_destroyed and context.card ~= card then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            jojoker.debug("Cheap Trick: A joker was destroyed, increasing XMult to "..card.ability.extra.Xmult)
        end

        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                jojoker.debug("Cheap Trick: Giving XMult of "..card.ability.extra.Xmult)
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
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.QUEENS, jojoker.themes.QUEENS_IN_HAND, jojoker.themes.FACE_CARDS } },
    similar = { jojoker.similar.RANK_CHANGERS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { is_disabled = false } },
    loc_vars = function(self, info_queue, card)
      return {
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
                jojoker.debug("Cinderella: Changing first card rank from "..rank_string_from_id(first_card_rank).." to "..rank_string_from_id(new_rank))

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
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.SEALS } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.25, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}
    }
    end,
    calculate = function(self, card, context)
        -- Give XMult during scoring
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                jojoker.debug("Atom Heart Father: Giving XMult of "..card.ability.extra.Xmult)
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
    part = "diamond_is_unbreakable",
    similar = { jojoker.similar.COPY_A_JOKER },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
      return {
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
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.EXTRA_ROUNDS }, support = { jojoker.themes.LUCK } },
    conflicts = { ghost_girl_alley = "can_rewind_the_ante_which" },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    config = { extra = { numerator = 1, denominator = 3 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.numerator, card.ability.extra.denominator }
    }
    end,
    calculate = function(self, card, context)
        -- When beating a boss, has a chance to rewind the blind
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not card.debuff then
            if SMODS.pseudorandom_probability(card, 'killer_queen', card.ability.extra.numerator, card.ability.extra.denominator, 'killer_queen') then
                jojoker.debug("Killer Queen: Rewinding blind after beating boss")
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
    part = "diamond_is_unbreakable",
    similar = { jojoker.similar.BOSS_BLIND_REWARDS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        -- When beating a boss, gives a random tag
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not card.debuff then
            jojoker.debug("Heaven's Door: Giving random tag after beating boss")
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
    part = "diamond_is_unbreakable",
    similar = { jojoker.similar.STREAK_SCALING },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult_gain = 5, curr_mult = 0, most_played = nil } },
    loc_vars = function(self, info_queue, card)
        local hand = card.ability.extra.most_played
        return { vars = {card.ability.extra.mult_gain, card.ability.extra.curr_mult, hand and localize(hand, 'poker_hands') or localize('none_used') } }
    end,
    calculate = function(self, card, context)
        -- When playing a hand, increase mult if it's the most played hand
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before then
                jojoker.debug("The Lock: Hand played is "..context.scoring_name..", most played hand is "..tostring(card.ability.extra.most_played))
                if get_most_played_hand_info().count == 1 or context.scoring_name == card.ability.extra.most_played then
                    jojoker.debug("The Lock: Gaining mult for most played hand")
                    card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.mult_gain
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.GOLD
                    }
                else
                    jojoker.debug("The Lock: Resetting mult for non-most played hand")
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
            local most_played = get_most_played_hand_info()
            card.ability.extra.most_played = most_played.count > 0 and most_played.name or nil
        end
    end
}

local harvest = {
    name = "harvest",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    themes = { support = { jojoker.themes.MONEY_HELD } },
    conflicts = { tarkus = "rewards_spending_in_the_shop" },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money_mod = 1, spend_per_payout = 15 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.money_mod, center.ability.extra.spend_per_payout, get_harvest_payout(center) }}
    end,
    calc_dollar_bonus = function(self, card)
        local payout = get_harvest_payout(card)
        if payout > 0 then
            jojoker.debug("Harvest: Giving $"..payout.." for $"..G.GAME.jojoker_shop_dollars_spent.." spent in shops this run.")
            return ease_joker_dollars(card, "Harvest", payout, true)
        end
    end
}

local echoes_act_3 = {
    name = "echoes_act_3",
    rarity = 3,
    cost = 8,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.HAND_SIZE, jojoker.themes.QUEENS_IN_HAND }, support = { jojoker.themes.ALL_QUEEN_DECK, jojoker.themes.DECK_SHRINKING } },
    conflicts = { suzi_q = "destroys_the_queens_suzi_q" },
    similar = { jojoker.similar.DESTROY_CARDS_FOR_XMULT },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult_mod = 0.5, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}
    }
    end,
    calculate = function(self, card, context)
        -- Destroy before scoring so the gain applies to the hand that killed the Queens
        if context.before and not context.blueprint then
            local queens = {}
            for _, held_card in ipairs(G.hand.cards) do
                if held_card:get_id() == 12 and not held_card.getting_sliced then
                    queens[#queens + 1] = held_card
                end
            end
            if #queens > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + #queens * card.ability.extra.Xmult_mod
                jojoker.debug("Echoes Act 3: Destroying "..#queens.." Queens held in hand, increasing XMult to "..card.ability.extra.Xmult)
                SMODS.destroy_cards(queens)
                return {
                    message = localize('sound_kill_da_hoe'),
                    colour = G.C.XMULT
                }
            end
        end

        -- Give XMult for each destroyed queen
        if context.joker_main and card.ability.extra.Xmult ~= 1 then
            jojoker.debug("Echoes Act 3: Giving XMult of "..card.ability.extra.Xmult)
            return {
                message = localize('sound_beeeetch'),
                colour = G.C.XMULT,
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}

local aqua_necklace = {
    name = "aqua_necklace",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.FLUSHES } },
    similar = { jojoker.similar.HAND_TYPE_CHIPS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 80 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.chips }}
    end,
    calculate = function(self, card, context)
        -- Gives chips when a flush is played
        if context.joker_main and next(context.poker_hands["Flush"]) then
            jojoker.debug("Aqua Necklace: Giving "..card.ability.extra.chips.." chips for hand containing a Flush")
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                colour = G.C.CHIPS,
                chip_mod = card.ability.extra.chips,
            }
        end
    end
}

local highway_star = {
    name = "highway_star",
    rarity = 2,
    cost = 6,
    jtype = "Stand",
    part = "diamond_is_unbreakable",
    themes = { core = { jojoker.themes.PERMANENT_BUFF_EATER } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 0, mult = 0 } },
    loc_vars = function(self, info_queue, center)
        return {vars = { center.ability.extra.chips, center.ability.extra.mult }}
    end,
    calculate = function(self, card, context)
        -- Drain before scoring so the stripped cards score without their bonuses this hand
        if context.before and not context.blueprint then
            local chips, mult = 0, 0
            for _, scoring_card in ipairs(context.scoring_hand) do
                if (scoring_card.ability.perma_bonus or 0) > 0 then
                    chips = chips + scoring_card.ability.perma_bonus
                    scoring_card.ability.perma_bonus = 0
                end
                if (scoring_card.ability.perma_mult or 0) > 0 then
                    mult = mult + scoring_card.ability.perma_mult
                    scoring_card.ability.perma_mult = 0
                end
            end
            if chips > 0 or mult > 0 then
                card.ability.extra.chips = card.ability.extra.chips + chips
                card.ability.extra.mult = card.ability.extra.mult + mult
                jojoker.debug("Highway Star: Absorbing "..chips.." chips and "..mult.." mult from scoring cards, now at "..card.ability.extra.chips.." chips and "..card.ability.extra.mult.." mult")
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
        end

        if context.joker_main and (card.ability.extra.chips > 0 or card.ability.extra.mult > 0) then
            jojoker.debug("Highway Star: Giving "..card.ability.extra.chips.." chips and "..card.ability.extra.mult.." mult")
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

return {
    name = "Diamond is Unbreakable Stand Jokers",
    list = { red_hot_chili_pepper, the_hand, superfly, crazy_diamond, bad_company, cheap_trick, cinderella, atom_heart_father, surface, killer_queen, heavens_door, the_lock, harvest, echoes_act_3, aqua_necklace, highway_star },
}