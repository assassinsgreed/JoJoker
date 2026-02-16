local jd_def = JokerDisplay.Definitions

jd_def["j_jojoker_mandom"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "status", retrigger_type = "mult" },
        { text = " Left" },
    },
    text_config = { colour = G.C.GREY },
    calc_function = function(card)
        card.joker_display_values.status = card.ability.extra.card_max - card.ability.extra.cards
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local remaining = joker_card.ability.extra.card_max - joker_card.ability.extra.cards
        if remaining >= #scoring_hand then return 1 end

        for i = 1, remaining do
            if playing_card == scoring_hand[i] then
                return 1
            end
        end
        return 0
    end,
}

jd_def["j_jojoker_the_fifth_lesson"] = {
    text = {
        { text = "Shortcut Active", colour = G.C.GREY },
    }
}

jd_def["j_jojoker_chocolate_disco"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "ante_value", retrigger_type = "ante_value" },
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "rank_type", retrigger_type = "rank_type", colour = G.C.GREY },
        { text = " this blind", colour = G.C.GREY }
    },
    calc_function = function(card)
        local isOddAnte = G.GAME.round_resets.blind_ante % 2 == 1

        if isOddAnte then
            card.joker_display_values.ante_value = card.ability.extra.chips
            card.joker_display_values.rank_type = "Odd"
        else
            card.joker_display_values.ante_value = card.ability.extra.mult
            card.joker_display_values.rank_type = "Even"
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        local isOddAnte = G.GAME and G.GAME.round_resets.blind_ante % 2 == 1
        text.children[1].config.colour = isOddAnte and G.C.CHIPS or G.C.MULT
        if text and text.children[2] then
            text.children[2].config.colour = isOddAnte and G.C.CHIPS or G.C.MULT
        end
        return false
    end
}

jd_def["j_jojoker_oh_lonesome_me"] = {
    text = {
        { text = "+", colour = G.C.GREEN },
        { ref_table = "card.ability.extra", ref_value = "hand_size", retrigger_type = "hand_size", colour = G.C.GREEN },
    },
    reminder_text = {
        { text = "Hand Size", colour = G.C.GREY }
    },
}

jd_def["j_jojoker_hey_ya"] = {
    text = {
        { text = "& always trigger", colour = G.C.GREY }, -- Presented under extra section
    },
    extra = {
        {
            { text = "Convert Lucky Card", colour = G.C.GREY }
        },
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "numerator", retrigger_type = "numerator",  colour = G.C.GOLD },
        { text = " in ", colour = G.C.GOLD },
        { ref_table = "card.ability.extra", ref_value = "denominator", retrigger_type = "denominator",  colour = G.C.GOLD },
    },
}