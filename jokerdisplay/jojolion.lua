local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_soft_and_wet"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    }
}

jd_def["j_jojoker_paper_moon_king"] = {
    text = {
        { text = "Pareidolia enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_josuke_higashikata_jjl"] = {
    text = {
        { text = "Four Fingers enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_milagro_man"] = {
    text = {
        { text = "Doubles interest", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_higashikata_house"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Full House", colour = G.C.GREY },
    }
}