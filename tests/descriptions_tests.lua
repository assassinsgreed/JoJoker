Balatest.TestPlay {
    name = 'owned_joker_shows_its_in_play_footer',
    category = { 'descriptions' },
    jokers = { 'j_jojoker_joseph_joestar' },
    assert = function()
        Balatest.assert_eq(description_key(G.jokers.cards[1]), 'j_jojoker_joseph_joestar_in_play', "An owned joker did not show its in-play footer")
    end
}
Balatest.TestPlay {
    name = 'unowned_joker_hides_its_in_play_footer',
    category = { 'descriptions' },
    assert = function()
        local card = SMODS.create_card { set = 'Joker', key = 'j_jojoker_joseph_joestar' }
        local key = description_key(card)
        card:remove()
        Balatest.assert_eq(key, 'j_jojoker_joseph_joestar', "A joker outside the joker area showed its in-play footer")
    end
}
Balatest.TestPlay {
    name = 'owned_joker_without_a_footer_keeps_its_description',
    category = { 'descriptions' },
    jokers = { 'j_jojoker_darby_brothers' },
    assert = function()
        Balatest.assert_eq(description_key(G.jokers.cards[1]), 'j_jojoker_darby_brothers', "A joker with no in-play footer changed its description key")
    end
}
