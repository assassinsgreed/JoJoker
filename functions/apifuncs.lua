jojoker.load_joker = function(item)
    item.discovered = true
    if not item.key then
        item.key = item.name
    end
    if not item.config then
        item.config = {}
    end
    if not item.joker_custom_prefix then
        joker_load_atlas(item)
        joker_load_sprites(item)
    end
    -- Type (Stand, User, Effect, etc.)
    if item.jtype then
        if item.config and item.config.extra then
            item.config.extra.jtype = item.jtype
        elseif item.config then
            item.config.extra = {jtype = item.jtype}
        end
    end

    -- Set detail badges
    item.set_badges = jojoker_set_joker_badges

    -- Footers only show on owned jokers; the collection, shop and compendium read the bare effect.
    -- Then programmatically set the joker names to localized or standard based on config
    local joker_loc_vars = item.loc_vars
    item.loc_vars = function(self, info_queue, card)
        local ret = joker_loc_vars and joker_loc_vars(self, info_queue, card) or {}
        local descriptions = G.localization.descriptions.Joker
        local key = ret.key or self.key
        if card and card.area and card.area == G.jokers and descriptions[key..'_in_play'] then
            key = key..'_in_play'
        end
        if jojoker_config.use_localized_names and descriptions[key..'_alt'] then
            key = key..'_alt'
        end
        ret.key = key
        return ret
    end

    local joker_calculate = item.calculate
    item.calculate = function(self, card, context)
        local ret, triggered
        if joker_calculate then
            ret, triggered = joker_calculate(self, card, context)
        end
        ret = jojoker_add_purple_haze_bonus(card, context, ret)
        return jojoker_add_notorious_xmult(card, context, ret), triggered
    end

    -- Load the Joker
    local prev_load = item.load
    item.load = function(self, card, card_table, other_card)
        if type(self.calculate) == "function" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    self:calculate(card, {joker_load = true})
                    return true
                end
            }))
        end
        joker_load_individual_sprite(self, card, card_table, other_card)
        if prev_load then
            prev_load(self, card, card_table, other_card)
        end
    end
    SMODS.Joker(item)
end

jojoker.Joker = function(item, custom_prefix)
    if custom_prefix then
        item.joker_custom_prefix = custom_prefix
    end
    -- TODO: Need no-custom atlas handling?
    jojoker.load_joker(item)
end