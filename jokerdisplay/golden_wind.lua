local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_sex_pistols"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Rank: ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "chosen_rank", retrigger_type = "chosen_rank",  colour = G.C.GREEN },
    }
}

jd_def["j_jojoker_grateful_dead"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Loses ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "mult_decay", retrigger_type = "mult_decay",  colour = G.C.GREY },
        { text = " after blind", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_spice_girl"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        {
            border_nodes = {
                { text = "X", colour = G.C.WHITE },
                { ref_table = "card.ability.extra", ref_value = "Xmult", colour = G.C.WHITE }
            }
        }
    }
}

jd_def["j_jojoker_sticky_fingers"] = {
    text = {
        { text = "Four Fingers enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_leaky_eye_luca"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Spades only", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_mista"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(4s)", colour = G.C.GREY },
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if text == "Four of a Kind" then
            local of_fours = is_four_of_a_kind_of_fours(poker_hands)
            card.joker_display_values.chips = of_fours and card.ability.extra.fours_hand_chips or card.ability.extra.hand_chips
            card.joker_display_values.mult = of_fours and card.ability.extra.fours_hand_mult or card.ability.extra.hand_mult
            return
        end
        local fours = 0
        for _, v in pairs(scoring_hand) do
            if v:get_id() == 4 and not v.debuff then
                fours = fours + JokerDisplay.calculate_card_triggers(v, scoring_hand)
            end
        end
        card.joker_display_values.chips = fours * card.ability.extra.card_chips
        card.joker_display_values.mult = fours * card.ability.extra.card_mult
    end
}

jd_def["j_jojoker_gold_experience"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Convert Polychrome", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_gold_experience_requiem"] = {
    text = {
        { text = "Disable boss blinds", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_king_crimson"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "Skipped Blinds", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_epitaph"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local chips = 0
        if G.scan_view then
            for k, v in pairs(G.scan_view.cards) do
                chips = chips + joker_total_chips(v) * (v:get_seal() == 'Red' and 2 or 1)
            end
            card.joker_display_values.chips = chips
        else
            card.joker_display_values.chips = 0
        end
    end
}

jd_def["j_jojoker_moody_blues"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Retrigger", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_baby_face"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Spawn Joker", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_little_feet"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "Per scored 2-5", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_black_sabbath"] = {
    extra = {
        {
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "curr_mult", retrigger_type = "curr_mult",  colour = G.C.MULT },
        },
        {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "curr_chips", retrigger_type = "curr_chips",  colour = G.C.CHIPS },
        }
    }
}

jd_def["j_jojoker_rolling_stones"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "XMult" }
            }
        }
    },
    reminder_text = {
        { text = "0% probabilities", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_seven_page_muda"] = {
    text = {
        { text = "First 7 retriggers", colour = G.C.GREY },
    },
}

-- Shown in the modifiers row of whichever joker destroyed Notorious B.I.G.
JokerDisplay.Edition_Definitions["jojoker_notorious"] = {
    condition_function = function(card)
        return not card.debuff and card.ability and card.ability.jojoker_notorious_xmult
    end,
    mod_function = function(card)
        return { x_mult = card.ability.jojoker_notorious_xmult }
    end
}

jd_def["j_jojoker_notorious_big"] = {
    reminder_text = {
        { text = "(X", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "Xmult", colour = G.C.GREY },
        { text = " to destroyer)", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_white_album"] = {
    text = {
        { text = "Perishable frozen", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_aerosmith"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(High Card)", colour = G.C.GREY },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local unscored = text == "High Card" and #JokerDisplay.current_hand - #scoring_hand or 0
        card.joker_display_values.xmult = 1 + unscored * card.ability.extra.xmult_mod
    end
}

-- Shown in the modifiers row of every joker Purple Haze has infected
JokerDisplay.Edition_Definitions["jojoker_purple_haze"] = {
    condition_function = function(card)
        return not card.debuff and card.ability and card.ability.jojoker_purple_haze_chips
    end,
    -- Previews the growth the next hand will add before scoring
    mod_function = function(card)
        local growth = G.P_CENTERS.j_jojoker_purple_haze.config.extra
        return { chips = card.ability.jojoker_purple_haze_chips + growth.chips_mod, mult = card.ability.jojoker_purple_haze_mult + growth.mult_mod }
    end
}

jd_def["j_jojoker_purple_haze"] = {
    reminder_text = {
        { text = "(+", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "chips_mod", colour = G.C.GREY },
        { text = "/+", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "mult_mod", colour = G.C.GREY },
        { text = " per hand)", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_talking_head"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Duplicate consumables", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_metallica"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
}
