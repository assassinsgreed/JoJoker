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
    -- Class, optional (Close Range, Automatic, etc.)
    if item.jclass then
        if item.config and item.config.extra then
            item.config.extra.jclass = item.jclass
        elseif item.config then
            item.config.extra = {jclass = item.jclass}
        end
    end

    -- Set detail badges
    item.set_badges = jojoker_set_joker_badges
    
    -- Load the Joker
    local prev_load = item.load
    item.load = function(self, card, card_table, other_card)
        if type(self.calculate) == "function" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    self:calculate(self, card, {joker_load = true})
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