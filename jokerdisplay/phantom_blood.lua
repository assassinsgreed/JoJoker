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

jd_def["j_jojoker_dario_brando"] = {
    text = {
        { text = "Steals ", colour = G.C.GREY },
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per hand played", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_erina"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult_given", retrigger_type = "mult_given",  colour = G.C.MULT },
    },
    calc_function = function(card)
        local character_count = get_joker_count_by_type("Character")
        card.joker_display_values.mult_given = character_count * card.ability.extra.mult_mod
    end
}

jd_def["j_jojoker_jonathan_joestar"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Per unique suit", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_sword_of_luck_and_pluck"] = {
    text = {
        { text = "3x", colour = G.C.GREEN },
    },
    reminder_text = {
        { text = "on Lucky Cards", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_dio_brando"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "drain_rate", retrigger_type = "drain_rate",  colour = G.C.GREY },
        { text = "% from drained chips", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_thunder_cross_split_attack"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_poco"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "When scoring <= ", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "score_threshold", retrigger_type = "score_threshold", colour = G.C.GREY },
        { text = " blind chips", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_vampiric_touch"] = {
    text = {
        { text = "Drain ", colour = G.C.GREY },
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "From each joker", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_tarkus"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_roundabout"] = {
    text = {
        { text = "+", colour = G.C.GREY },
        { ref_table = "card.joker_display_values", ref_value = "retriggers", colour = G.C.GREY },
        { text = " retriggers", colour = G.C.GREY },
    },
    reminder_text = {
        { text = "Per unscored card", colour = G.C.GREY },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local unscored = text ~= "Unknown" and #JokerDisplay.current_hand - #scoring_hand or 0
        card.joker_display_values.retriggers = unscored * card.ability.extra.retriggers_per
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return joker_card.joker_display_values and joker_card.joker_display_values.retriggers or 0
    end,
}

jd_def["j_jojoker_wang_chan"] = {
    text = {
        { text = "+1 Planet", colour = G.C.SECONDARY_SET.Planet }
    },
    reminder_text = {
        { text = "Of winning hand", colour = G.C.GREY }
    },
}
