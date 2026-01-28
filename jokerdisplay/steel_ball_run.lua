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