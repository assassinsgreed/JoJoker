local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_sex_pistols"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Rank: ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "chosen_rank", retrigger_type = "chosen_rank",  colour = G.C.GREEN },
    }
}
