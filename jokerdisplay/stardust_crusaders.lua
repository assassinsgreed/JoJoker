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
