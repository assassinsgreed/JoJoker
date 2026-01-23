local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_joseph_joestar"] = {
    text = {
        { text = "Level up", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "jokerdisplay_hand_name", retrigger_type = "jokerdisplay_hand_name",  colour = G.C.GREEN },
        { text = "when played", colour = G.C.GREY }
    },
    reminder_text = {
        { text = "Changes each blind", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_esidisi"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "Xmult",  colour = G.C.MULT },
        { text = "x", colour = G.C.MULT }
    }
}
