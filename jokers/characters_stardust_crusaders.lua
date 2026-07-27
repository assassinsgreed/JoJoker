-- Stardust Crusaders Characters

local ndoul = {
    name = "ndoul",
    rarity = 2,
    cost = 7,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
      info_queue[#info_queue + 1] = { set = 'Joker', key = 'j_smeared', config = {} }
      return {
        vars = {},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
    }
    end
}

local old_joseph_joestar = {
    name = "old_joseph_joestar",
    rarity = 3,
    cost = 5,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { numerator = 1, denominator = 2, Xmult_mod = 0.15, Xmult = 1 } },
    loc_vars = function(self, info_queue, center)
      return {vars = {center.ability.extra.numerator, center.ability.extra.denominator, center.ability.extra.Xmult_mod, center.ability.extra.Xmult}, key = self.key}
    end,
    calculate = function(self, card, context)
        -- On discard, have a chance to quip and increase XMult
        if context.pre_discard then
            if SMODS.pseudorandom_probability(card, 'old_joseph_joestar', card.ability.extra.numerator, card.ability.extra.denominator, 'old_joseph_joestar') then
                sendDebugMessage("Old Joesph Joestar: Quipping and increasing Xmult")
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod

                local quips = {
                    "sound_joseph_quip_oh_my_god",
                    "sound_joseph_quip_oh_no",
                    "sound_joseph_quip_holy_shit",
                    "sound_joseph_quip_son_of_a_bitch"
                }
                return {
                    message = localize(quips[math.random(#quips)]),
                    colour = G.C.GOLD
                }
            end
        end

        -- On scoring, apply Xmult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                    colour = G.C.XMULT,
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local hol_horse = {
    name = "hol_horse",
    rarity = 1,
    cost = 6,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {} },
    calculate = function(self, card, context)
        -- If scoring hand is a pair, give all unscored cards the rank as mult
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main and context.scoring_name == "Pair" then
                local mult = 0
                for _, unscored_card in pairs(context.full_hand) do
                    if not SMODS.in_scoring(unscored_card, context.scoring_hand) then
                        mult = mult + unscored_card:get_id()
                    end
                end
                return {
                    message = localize{type = 'variable', key = 'a_mult', vars = {mult}},
                    colour = G.C.MULT,
                    mult_mod = mult
                }
            end
        end
    end
}

local darby_brothers = {
    name = "darby_brothers",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        -- Doubles all probabilities
        if context.fix_probability then
            return {
                numerator = context.numerator * 2
            }
        end
    end
}

local enya = {
    name = "enya",
    rarity = 2,
    cost = 6,
    jtype = "Character",
    part = "stardust_crusaders",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { most_used_tarot_key = nil, most_used_tarot_name = "none" } }, -- Default for displayed strings in desc & jokerdisplay
    loc_vars = function(self, info_queue, card)
      return {
        vars = {card.ability.extra.most_used_tarot_name},
        key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
      }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local tarot = get_most_used_tarot_info()
            if tarot.key ~= card.ability.extra.most_used_tarot_key then
                sendDebugMessage("Enya: Most used tarot is now "..tarot.name)
                card.ability.extra.most_used_tarot_key = tarot.key
                card.ability.extra.most_used_tarot_name = tarot.name
            end
        end
    end
}

return {
    name = "Stardust Crusaders Character Jokers",
    list = { ndoul, old_joseph_joestar, hol_horse, darby_brothers, enya },
}