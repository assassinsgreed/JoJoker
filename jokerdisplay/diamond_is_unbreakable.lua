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
