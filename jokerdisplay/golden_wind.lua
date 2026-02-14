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
