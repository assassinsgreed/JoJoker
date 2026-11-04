if SMODS.JimboQuip then
    for i=1,10 do
        SMODS.JimboQuip {
            key = 'lose_quip'..tostring(i),
            type = 'loss',
            extra = { center = 'j_jojoker_rolling_stones' }
        }
    end

    for i=1,10 do
        SMODS.JimboQuip {
            key = 'win_quip'..tostring(i),
            type = 'win',
            extra = { center = 'j_jojoker_rolling_stones' }
        }
    end
end
