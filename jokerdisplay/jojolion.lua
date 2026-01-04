local jd_def = JokerDisplay.Definitions

jd_def["j_stand_soft_and_wet"] = {
    text = {
        { text = "+", color = G.C.MULT},
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT  },
    }
}