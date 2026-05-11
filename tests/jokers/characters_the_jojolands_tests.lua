--#region Jodio Joestar
Balatest.TestPlay {
    name = 'jodio_joestar_gives_money_for_scored_gold_cards',
    category = { 'jokers', 'jodio_joestar' },
    jokers = { 'j_jojoker_jodio_joestar' },
    deck = { cards = {
        { r = '3', s = 'S', e = 'm_gold' },
        { r = '3', s = 'C', e = 'm_gold' },
        { r = '2', s = 'H', e = 'm_gold' },
        { r = '2', s = 'D' } } },
    execute = function()
        Balatest.play_hand { '3S', '3C', '2H' }
    end,
    assert = function()
        Balatest.assert_dollars(G.jokers.cards[1].ability.extra.money_mod * 2, "Jodio Joestar did not give the correct amount of money for scored gold cards")
    end
}
--#endregion