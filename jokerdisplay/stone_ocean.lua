local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_goo_goo_dolls"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Per scored 2-6", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_stone_free"] = {
    text = {
        { text = "Retrigger stone", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_made_in_heaven"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "1 hand, max hand size", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_dragons_dream"] = {
    extra = {
        {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "curr_Xmult" }
                }
            }
        },
        {
            { text = "+", colour = G.C.MONEY },
            { ref_table = "card.ability.extra", ref_value = "curr_money", retrigger_type = "curr_money",  colour = G.C.MONEY },
        },
        {
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "curr_mult", retrigger_type = "curr_mult",  colour = G.C.MULT },
        },
        {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "curr_chips", retrigger_type = "curr_chips",  colour = G.C.CHIPS },
        }
    },
    reminder_text = {
        { text = "Changes when hand played", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_green_green_grass_of_home"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xchips" }
            },
            border_colour = G.C.CHIPS
        }
    },
    reminder_text = {
        { text = "High Card", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_survivor"] = {
    text = {
        { text = "Splash enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_foo_fighters"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
}

jd_def["j_jojoker_savage_garden"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_foo_fighters"] = {
    text = {
        { text = "Retrigger primes", colour = G.C.GREY },
    },
    reminder_text = {
        { text = "(2, 3, 5, 7, Jack, King)", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_white_snake"] = {
    text = {
        { text = "Convert Wild", colour = G.C.GREY }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
}
