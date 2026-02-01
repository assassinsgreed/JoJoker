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
