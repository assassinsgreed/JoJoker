local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_soft_and_wet"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    }
}

jd_def["j_jojoker_paper_moon_king"] = {
    text = {
        { text = "Pareidolia enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_josuke_higashikata_jjl"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Two Pair", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_milagro_man"] = {
    text = {
        { text = "Doubles interest", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_higashikata_house"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Full House", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_higashikata_fruit_parlor"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "pair_money", retrigger_type = "pair_money",  colour = G.C.MONEY },
        { text = " / $", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "two_pair_money", retrigger_type = "two_pair_money",  colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Pair / Two Pair", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_i_am_a_rock"] = {
    text = {
        { text = "Unscored to Stone", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_california_king_bed"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_doctor_wu"] = {
    text = {
        { text = "Stone card on blind", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_wonder_of_u"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "rounds_left", retrigger_type = "rounds_left",  colour = G.C.GREY },
        { text = " rounds remaining", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_paisley_park"] = {
    text = {
        { text = "+", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "booster_limit", retrigger_type = "booster_limit",  colour = G.C.GOLD },
        { text = " booster packs", colour = G.C.GOLD }
    },
    reminder_text = {
        { text = "In Shops", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_space_trucking"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Make held consumable negative", colour = G.C.GREY, },
    },
}
