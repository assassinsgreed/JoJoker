local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_smooth_operator"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Per scored card", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_jodio_joestar"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per scored gold card", colour = G.C.GREY },
    }
}