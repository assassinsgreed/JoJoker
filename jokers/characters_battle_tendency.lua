-- Battle Tendency characters

local joseph_joestar = {
    name = "joseph_joestar",
    rarity = 1,
    cost = 4,
    jtype = "Character",
    part = "battle_tendency",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chosen_hand_type_name = "undecided", jokerdisplay_hand_name = "a hand" } }, -- Default for displayed strings in desc & jokerdisplay
    loc_vars = function(self, info_queue, card)
      return {vars = {card.ability.extra.chosen_hand_type_name}}
    end,
    calculate = function(self, card, context)
        -- When blind is starting, choose a random hand type (only "visible" ones are chosen, i.e. ones the player can/has played)
        local hand_options = {}
        local hand_names = {}
        if context.setting_blind then
            for k,v in pairs(G.GAME.hands) do
                if v.visible then
                    local hand = v
                    hand.handname = k
                    table.insert(hand_options, hand)
                    table.insert(hand_names, hand.handname)
                end
            end

            if #hand_options > 0 then
                local hand = hand_options[math.random(#hand_options)]
                card.ability.extra.chosen_hand_type_name = hand.handname
                card.ability.extra.jokerdisplay_hand_name = hand.handname
                sendDebugMessage("Joseph Joestar: Chose hand "..hand.handname.." out of options "..table.concat(hand_names, ", "))
                
                return {
                    message = localize("sound_prediction")
                }
            end
        end

        -- Level up hand type when played
        if context.cardarea == G.jokers and context.scoring_hand then
            if not context.blueprint then
                if context.before and next(context.poker_hands[card.ability.extra.chosen_hand_type_name]) then
                    sendDebugMessage("Joseph Joestar: Leveling up hand "..card.ability.extra.chosen_hand_type_name)
                    SMODS.smart_level_up_hand(card, card.ability.extra.chosen_hand_type_name)
                    return {
                        message = localize('sound_nice')
                    }
                end
            end
        end

        -- When blind ends, reset display strings
        if context.end_of_round then
            card.ability.extra.chosen_hand_type_name = localize("undecided")
            card.ability.extra.jokerdisplay_hand_name = localize("a_hand")
        end
    end
}

return {
    name = "Battle Tendency Character Jokers",
    list = { joseph_joestar },
}