local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_voice_of_love"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Hearts only", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_shizuka"] = {
    text = {
        { text = "Secret hand", colour = G.C.GREEN }
    },
    reminder_text = {
        { text = "+", colour = G.C.GREY, },
        { ref_table = "card.ability.extra", ref_value = "levels", colour = G.C.GREY},
        { text = " levels when played", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_red_hot_chili_pepper"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult_given", retrigger_type = "mult_given",  colour = G.C.MULT },
    },
    calc_function = function(card)
        if G.GAME and G.GAME.dollars > 0 then
            card.joker_display_values.mult_given = card.ability.extra.mult_mod * G.GAME.dollars
        else
            card.joker_display_values.mult_given = 0
        end
    end
}

jd_def["j_jojoker_the_hand"] = {
    extra = {
        {
            { text = "Boosted ", colour = G.C.GREY },
            { ref_table = "card.ability.extra", ref_value = "buffed_rank_one", colour = G.C.GREEN},
            { text = " & ", colour = G.C.GREY },
            { ref_table = "card.ability.extra", ref_value = "buffed_rank_two", colour = G.C.GREEN},
        },
        {
            { text = "Debuffed ", colour = G.C.GREY, },
            { ref_table = "card.ability.extra", ref_value = "debuff_rank", colour = G.C.RED},
        },
        {
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult_mod", retrigger_type = "mult_mod",  colour = G.C.MULT }
        }
    }
}

jd_def["j_jojoker_superfly"] = {
    text = {
        { text = "Disable boss blind", colour = G.C.GREY }
    },
    reminder_text = {
        { text = "When sold", colour = G.C.GREY, }
    }
}

jd_def["j_jojoker_crazy_diamond"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult",  colour = G.C.MULT },
    },
    reminder_text = {
        { text = "Diamonds only", colour = G.C.GREY, },
    },
}

jd_def["j_jojoker_bad_company"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table ="card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = ">", colour = G.C.GREY, },
        { ref_table = "card.joker_display_values", ref_value = "starting_deck_size", retrigger_type = "starting_deck_size",  colour = G.C.GREY },
        { text = " in deck", colour = G.C.GREY, },
    },
    calc_function = function(card)
        local mult = 0
        if #G.playing_cards > G.GAME.starting_deck_size then
            mult = card.ability.extra.mult * (#G.playing_cards - G.GAME.starting_deck_size)
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.starting_deck_size = G.GAME.starting_deck_size
    end
}

jd_def["j_jojoker_cheap_trick"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

jd_def["j_jojoker_yoshikage_kira"] = {
    text = {
        { text = "+", colour = G.C.GREY },
        { ref_table = "card.ability.extra", ref_value = "hands", colour = G.C.GREY },
        { text = " hands", colour = G.C.GREY },
    }
}
