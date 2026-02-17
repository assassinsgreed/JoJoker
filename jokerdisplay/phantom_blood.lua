local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_danny"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "SD's on fire score", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_baron_zeppeli"] = {
    text = {
        { text = "-50% scored chips", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "+20% original chips", colour = G.C.MULT },
    }
}

jd_def["j_jojoker_speedwagon"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per used discard", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_zombies"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current_mult", retrigger_type = "current_mult", colour = G.C.MULT },
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "mult_per", retrigger_type = "mult_per", colour = G.C.GREY },
        { text = "^{held Zombies}", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_straizo"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips_straight", retrigger_type = "chips_straight",  colour = G.C.CHIPS },
        { text = " / ", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips_straight_flush", retrigger_type = "chips_straight_flush",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Straight / Straight Flush", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_george_joestar"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per held joker", colour = G.C.GREY },
    }
}
