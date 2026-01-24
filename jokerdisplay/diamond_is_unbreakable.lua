local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_voice_of_love"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Hearts only", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_shizuka"] = {
    text = {
        { text = "Secret hand", colour = G.C.GREY }        
    },
    reminder_text = {
        { text = "+", colour = G.C.GREY, },
        { ref_table = "card.ability.extra", ref_value = "levels", colour = G.C.GREY},
        { text = " levels when played", colour = G.C.GREY }
    },
}
