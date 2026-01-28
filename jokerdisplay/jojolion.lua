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