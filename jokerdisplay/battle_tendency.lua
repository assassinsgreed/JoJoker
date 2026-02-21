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
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
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
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult_mod" }
            }
        }
    },
    reminder_text = {
        { text = "Per scored stone card", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_kars_ultimate_lifeform"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "Stops thinking in: ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "current_rounds_left", retrigger_type = "current_rounds_left",  colour = G.C.MULT },
    }
}

jd_def["j_jojoker_kars_stopped_thinking"] = {
    text = {
        { text = "Stopped thinking", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_suzi_q"] = {
    text = {
        { text = "Gold Seal", colour = G.C.GREY }
    },
    reminder_text = {
        { text = "Queens only", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_nypd"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Clubs only", colour = G.C.GREY, },
    },
}
