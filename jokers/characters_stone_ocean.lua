-- Stone Ocean Characters

local savage_garden = {
    name = "savage_garden",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        -- Gives xmult on the final hand 
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and G.GAME.current_round.hands_left == 0 then
                jojoker.debug("Savage Garden: Applying Xmult to final hand")
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local pucci = {
    name = "pucci",
    rarity = 2,
    cost = 4,
    jtype = "Character",
    part = "stone_ocean",
    themes = { core = { jojoker.themes.JACKS, jojoker.themes.SEVENS, jojoker.themes.ACES_AND_KINGS }, support = { jojoker.themes.RETRIGGERS } },
    similar = { jojoker.similar.RANK_RETRIGGERS },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { retriggers = 1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        -- Retriggers prime ranks
        local prime_ranks = { [2] = true, [3] = true, [5] = true, [7] = true, [11] = true, [13] = true }
        if context.repetition and not context.end_of_round and context.cardarea == G.play then
            if context.other_card and prime_ranks[context.other_card:get_id()] then
                jojoker.debug("Pucci: Retriggering on prime rank "..context.other_card:get_id())
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    end
}

local loccobarocco_and_charlotte = {
    name = "loccobarocco_and_charlotte",
    rarity = 1,
    cost = 3,
    jtype = "Character",
    part = "stone_ocean",
    themes = { core = { jojoker.themes.DEBUFFED_CARDS } },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chip_multiplier = 5 } },
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.chip_multiplier}}
    end,
    calculate = function(self, card, context)
        -- Debuffed cards are skipped by scoring entirely, so their chips are paid out from the joker
        if context.joker_main then
            local chips = get_loccobarocco_chips(card, context.scoring_hand)
            if chips > 0 then
                jojoker.debug("Loccobarocco and Charlotte: Giving "..chips.." chips for debuffed scored cards")
                return {
                    message = localize{type='variable', key='a_chips', vars={chips}},
                    colour = G.C.CHIPS,
                    chip_mod = chips,
                }
            end
        end
    end
}

local anasui_m = {
    name = "anasui_m",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stone_ocean",
    themes = { support = { jojoker.themes.HANDS_PLAYED, jojoker.themes.MADE_IN_HEAVEN } },
    conflicts = { speedwagon = "takes_away_a_discard", old_joseph_joestar = "takes_away_a_discard", toilet_pig = "takes_away_a_discard", boku_no_rhythm_wo_kiitekure = "takes_away_a_discard" },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { hands = 2, discards = -1 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { math.abs(card.ability.extra.hands), math.abs(card.ability.extra.discards) }}
    end,
    -- +2 hands, -1 discards while in deck
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            jojoker.debug("Anasui (Male): Added to deck, changing hands by "..card.ability.extra.hands.." and discards by "..card.ability.extra.discards)
            shift_hands_and_discards(card.ability.extra.hands, card.ability.extra.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- Must mirror the from_debuff check in add_to_deck, or each debuff cycle permanently shifts the totals
        if not from_debuff then
            jojoker.debug("Anasui (Male): Removing from deck, reverting hands and discards")
            shift_hands_and_discards(-card.ability.extra.hands, -card.ability.extra.discards)
        end
    end
}

local anasui_f = {
    name = "anasui_f",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stone_ocean",
    themes = { support = { jojoker.themes.DISCARDS, jojoker.themes.MADE_IN_HEAVEN } },
    conflicts = { speedwagon_bt = "takes_away_a_hand", the_true_mans_world = "takes_away_a_hand", california_king_bed = "takes_away_a_hand", horus = "takes_away_a_hand", star_platinum = "takes_away_a_hand", under_world = "takes_away_a_hand" },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { hands = -1, discards = 2 } },
    loc_vars = function(self, info_queue, card)
      return {vars = { math.abs(card.ability.extra.hands), math.abs(card.ability.extra.discards) }}
    end,
    -- -1 hands, +2 discards while in deck
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            jojoker.debug("Anasui (Female): Added to deck, changing hands by "..card.ability.extra.hands.." and discards by "..card.ability.extra.discards)
            shift_hands_and_discards(card.ability.extra.hands, card.ability.extra.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- Must mirror the from_debuff check in add_to_deck, or each debuff cycle permanently shifts the totals
        if not from_debuff then
            jojoker.debug("Anasui (Female): Removing from deck, reverting hands and discards")
            shift_hands_and_discards(-card.ability.extra.hands, -card.ability.extra.discards)
        end
    end
}

local johngalli_a = {
    name = "johngalli_a",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stone_ocean",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
      return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.blueprint then return end

        -- Facing is set rather than flipped so a second copy cannot turn the card back over
        if context.modify_shop_card and context.card.ability.set == 'Joker' then
            jojoker.debug("Johngalli A: Dealing "..context.card.config.center.key.." face down")
            context.card.facing = 'back'
            context.card.sprite_facing = 'back'
        end
        if context.buying_card and context.card ~= card and context.card.ability.set == 'Joker' and not context.card.edition then
            jojoker.debug("Johngalli A: Giving "..context.card.config.center.key.." an edition")
            context.card:set_edition(poll_edition('johngalli_a', nil, true, true))
        end
    end
}

return {
    name = "Stone Ocean Character Jokers",
    list = { savage_garden, pucci, loccobarocco_and_charlotte, anasui_m, anasui_f, johngalli_a },
}