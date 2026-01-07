get_part_allowed = function(card)
    local part_allowed = false
    if card.part then
        local part = card.part
        if part == "phantom_blood" and jojoker_config.phantom_blood then part_allowed = true end
        if part == "battle_tendency" and jojoker_config.battle_tendency then part_allowed = true end
        if part == "stardust_crusaders" and jojoker_config.stardust_crusaders then part_allowed = true end
        if part == "diamond_is_unbreakable" and jojoker_config.diamond_is_unbreakable then part_allowed = true end
        if part == "golden_wind" and jojoker_config.golden_wind then part_allowed = true end
        if part == "stone_ocean" and jojoker_config.stone_ocean then part_allowed = true end
        if part == "steel_ball_run" and jojoker_config.steel_ball_run then part_allowed = true end
        if part == "jojolion" and jojoker_config.jojolion then part_allowed = true end
        if part == "the_jojolands" and jojoker_config.the_jojolands then part_allowed = true end
    else
        part_allowed = true
    end
    return part_allowed
end

joker_load_individual_sprite = function(self, card, initial, delay_sprites)
    if initial and card and card.ability and card.ability.extra and not card.ability.extra.loaded_pos then
        card.ability.extra.loaded_pos = card.config.center.pos
    end
end