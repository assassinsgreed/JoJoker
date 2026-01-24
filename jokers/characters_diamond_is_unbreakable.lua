-- Diamond is Unbreakable characters

local shizuka = {
    name = "shizuka",
    rarity = 2,
    cost = 4,
    jtype = "Character",
    part = "diamond_is_unbreakable",
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { levels = 3, chosen_hand_type_name = nil } },
    loc_vars = function(self, info_queue, card)
      return {vars = { card.ability.extra.levels }}
    end,
    calculate = function(self, card, context)
        -- When blind is starting and hand hasn't been chosen yet, choose a random hand type (only "visible" ones are chosen, i.e. ones the player can/has played)
        if context.setting_blind then
            if not card.ability.extra.chosen_hand_type_name then
                local hand = pick_random_hand_type()
                card.ability.extra.chosen_hand_type_name = hand.handname
                sendDebugMessage("Shizuka: Chose a new hand type")
            end
        end

        -- Level up hand type when played and choose a new one
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.before and next(context.poker_hands[card.ability.extra.chosen_hand_type_name]) then
                sendDebugMessage("Shizuka: Leveling up hand "..card.ability.extra.chosen_hand_type_name.." and choosing a new one.")
                SMODS.upgrade_poker_hands({hands = {card.ability.extra.chosen_hand_type_name}, level_up = card.ability.extra.levels, from = card})
                card.ability.extra.chosen_hand_type_name = pick_random_hand_type().handname
                return {
                    message = localize("sound_gaa")
                }
            end
        end
    end
}

return {
    name = "Diamond is Unbreakable Character Jokers",
    list = { shizuka },
}