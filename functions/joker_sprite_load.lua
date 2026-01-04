JokerSprites = {
    lookup = {},
    list = {
        -- TODO: Others
        {name = "soft_and_wet", base = {pos = {x = 0, y = 0}},},
    }
}

for i, sprite in ipairs(JokerSprites.list) do
    JokerSprites.lookup[sprite.name] = i
end

setmetatable(JokerSprites, {
    __index = function(_, key)
        return JokerSprites.list[JokerSprites.lookup[key]]
    end
})

jojoker_load_sprites = function(item)
    local sprite_info = JokerSprites[item.name]
    local sprite = nil
    local new_pos = {}
    if sprite_info then
        sprite = sprite_info.base
        local position = sprite.pos.x and sprite.pos or nil
        if not position then -- Randomly grab a sprite if we couldn't load one; oops!
            position = sprite.pos[math.random(#sprite.pos)]
        end
        new_pos.x = position.x
        new_pos.y = position.y
        local soul_position = sprite.soul_pos

        if position then item.pos = new_pos end
        if soul_position then item.soul_pos = soul_position end
    end
end

jojoker_get_atlas_string = function(atlas_prefix, part_atlas, other_atlas)
    if part_atlas then
        local part_string
        part_string = 'Part'..part_atlas
        return atlas_prefix..part_string
    elseif other_atlas then
        return atlas_prefix.."Others"
    end
end

jojoker_load_atlas = function(item)
    if JokerSprites[item.name] then
        local sprite_info = JokerSprites[item.name]
        local atlas_prefix = "AtlasJokersBasic" -- We only support a single sprite source currently
        item.atlas = jojoker_get_atlas_string(atlas_prefix, sprite_info.part_atlas, sprite_info.other_atlas)
        if sprite_info.lookup_part_atlas then
            item.jojoker_lookup_atlas = jojoker_get_atlas_string(atlas_prefix, sprite_info.lookup_part_atlas)
        end
    end
end