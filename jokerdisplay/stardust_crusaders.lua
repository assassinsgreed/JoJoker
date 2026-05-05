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

jd_def["j_jojoker_yellow_temperance"] = {
    text = {
        { text = "Retrigger face cards", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_ndoul"] = {
    text = {
        { text = "Smeared enabled", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_star_platinum"] = {
    text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
    reminder_text = {
        { text = "Not consume hand", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_wheel_of_fortune"] = {
    text = {
        { text = "Wheel of Fortune", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_the_lovers"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult_mod", retrigger_type = "mult_mod",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Added to scored Heart", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_old_joseph_joestar"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_anubis"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    }
}

jd_def["j_jojoker_sethan"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_the_world"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_death_thirteen"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Destroys joker to left", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_tenore_sax"] = {
    text = {
        { text = "New hand after scoring", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_khnum"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.GREY },
        { text = ")" }
    },
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        card.joker_display_values.blueprint_compat = localize('k_incompatible')
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        return G.jokers.cards[#G.jokers.cards]
    end
}

jd_def["j_jojoker_hol_horse"] = {
    text = {
        { text = "Unscored rank to ", colour = G.C.GREY },
        { text = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "Pair only", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_darby_brothers"] = {
    text = {
        { text = "Doubles listed probabilities", colour = G.C.GREY },
    },
}

jd_def["j_jojoker_hierophant_green"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "If within ", colour = G.C.GREY, },
        { ref_table = "card.ability.extra", ref_value = "rank_diff", retrigger_type = "rank_diff",  colour = G.C.GREY },
        { text = " ranks of each other", colour = G.C.GREY, }
    }
}

jd_def["j_jojoker_the_fool"] = {
    text = {
        { text = "Transforms on blind start", colour = G.C.GREY }
    }
}

jd_def["j_jojoker_thoth"] = {
    text = {
        { text = "+", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "level_change_up", retrigger_type = "level_change_up", colour = G.C.GOLD },
        { text = "/-", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "level_change_down", retrigger_type = "level_change_down", colour = G.C.GOLD },
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "chosen_hand_type", retrigger_type = "chosen_hand_type", colour = G.C.GREY }
    }
}
