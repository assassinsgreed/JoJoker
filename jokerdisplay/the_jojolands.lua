local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_smooth_operator"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "Per scored card", colour = G.C.GREY, },
    }
}

jd_def["j_jojoker_john_rod"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_jodio_joestar"] = {
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "money_mod", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "Per scored gold card", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_hacca_howler"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "chips", colour = G.C.CHIPS },
    },
    calc_function = function(card)
        card.joker_display_values.chips = math.floor(math.max(0, G.GAME.dollars) / card.ability.extra.dollars_per) * card.ability.extra.chips_mod
    end
}

jd_def["j_jojoker_november_rain"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        local middle_card = scoring_hand[math.ceil(#scoring_hand / 2)]
        local triggers = middle_card and not middle_card.debuff and JokerDisplay.calculate_card_triggers(middle_card, scoring_hand) or 0
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ triggers
    end
}