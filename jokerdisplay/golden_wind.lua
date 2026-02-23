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
        { text = " after blind", coulour = G.C.GREY }
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

jd_def["j_jojoker_gold_experience"] = {
    text = {
        { text = "Convert Polychrome", colour = G.C.GREY }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
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
    }
}
