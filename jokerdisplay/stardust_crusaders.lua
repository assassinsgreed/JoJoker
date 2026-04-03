local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_magician_red"] = {
    text = {
        { text = "+$", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "on fire score", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_yellow_temperance"] = {
    text = {
        { text = "Retrigger face cards", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_ndoul"] = {
    text = {
        { text = "Smeared enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_star_platinum"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Not consume hand", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_wheel_of_fortune"] = {
    text = {
        { text = "Wheel of Fortune", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_the_lovers"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult_mod", retrigger_type = "mult_mod",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Added to scored Heart", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_old_joseph_joestar"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_anubis"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    }
}

jd_def["j_jojoker_sethan"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_the_world"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_death_thirteen"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Destroys joker to left", colour = G.C.GREY, },
    }
}
