-- Stone Ocean Stands

local goo_goo_dolls = {
    name = "goo_goo_dolls",
    pos = { x = 0, y = 0 }, -- Index in spritesheet
    rarity = 1,
    cost = 3,
    jtype = "Stand",
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, center)
     return {vars = {center.ability.extra.mult}}
   end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            local id = context.other_card:get_id()
            if id and id >= 2 and id <= 6 then
                sendDebugMessage("Goo Goo Dolls: Scored card is rank: "..id)
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}

return {
    name = "Stone Ocean Stands Jokers",
    list = { goo_goo_dolls },
}