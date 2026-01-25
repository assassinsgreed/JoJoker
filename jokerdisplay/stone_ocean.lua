local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_goo_goo_dolls"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Per scored 2-6", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_stone_free"] = {
    text = {
        { text = "Retrigger stone", colour = G.C.GREY, },
    },
}
