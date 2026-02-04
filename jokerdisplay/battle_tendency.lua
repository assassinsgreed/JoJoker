local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_joseph_joestar"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "jokerdisplay_hand_name", retrigger_type = "jokerdisplay_hand_name",  colour = G.C.GREEN },
    },
    reminder_text = {
        { text = "Changes each blind", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_esidisi"] = {
    text = {
        { text = "X", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "Xmult",  colour = G.C.MULT },
    }
}

jd_def["j_jojoker_german_engineering"] = {
    text = {
        { text = "9 High Card", colour = G.C.GREEN }
    },
    reminder_text = {
        { text = "(Dupes, Levels Up)", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_speedwagon_bt"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per played hand", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_caesar"] = {
    text = {
        { text = "X", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "Xmult_mod", retrigger_type = "Xmult_mod",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Per scored stone card", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_kars_ultimate_lifeform"] = {
    text = {
        { text = "X", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "Xmult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Stops thinking after ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "current_rounds_left", retrigger_type = "current_rounds_left",  colour = G.C.MULT },
        { text = " round(s)", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_kars_stopped_thinking"] = {
    text = {
        { text = "Stopped thinking", colour = G.C.GREY }
    }
}
