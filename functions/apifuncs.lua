jojoker.load_joker = function(item)
    item.discovered = true
    if not item.key then
        item.key = item.name
    end
    if not item.config then
        item.config = {}
    end
    if not item.jojoker_custom_prefix then
        jojoker_load_atlas(item)
        jojoker_load_sprites(item)
    end
    if item.ptype then
        if item.config and item.config.extra then
            item.config.extra.ptype = item.ptype
        elseif item.config then
            item.config.extra = {ptype = item.ptype}
        end
    end
    local prev_load = item.load
    item.load = function(self, card, card_table, other_card)
        if type(self.calculate) == "function" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    self:calculate(self, card, {jojoker_load = true})
                    return true
                end
            }))
        end
        jojoker_load_individual_sprite(self, card, card_table, other_card)
        if prev_load then
            prev_load(self, card, card_table, other_card)
        end
    end
    SMODS.Joker(item)
end

jojoker.Joker = function(item, custom_prefix)
    if custom_prefix then
        item.jojoker_custom_prefix = custom_prefix
    end
    jojoker.load_joker(item)
end