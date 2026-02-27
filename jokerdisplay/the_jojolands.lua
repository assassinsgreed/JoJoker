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