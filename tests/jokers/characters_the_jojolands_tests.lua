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

--#region Hacca Howler

Balatest.TestPlay {
    name = 'hacca_howler_gives_chips_for_every_twenty_dollars_held',
    category = { 'jokers', 'the_jojolands', 'hacca_howler' },
    jokers = { 'j_jojoker_hacca_howler' },
    dollars = 20,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.chips_mod, "Hacca Howler did not give chips for $20 held")
    end
}

Balatest.TestPlay {
    name = 'hacca_howler_only_counts_full_twenty_dollar_steps',
    category = { 'jokers', 'the_jojolands', 'hacca_howler' },
    jokers = { 'j_jojoker_hacca_howler' },
    dollars = 59,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 + 2 * G.jokers.cards[1].ability.extra.chips_mod, "Hacca Howler did not give chips for each full $20 held")
    end
}

Balatest.TestPlay {
    name = 'hacca_howler_gives_no_chips_under_twenty_dollars',
    category = { 'jokers', 'the_jojolands', 'hacca_howler' },
    jokers = { 'j_jojoker_hacca_howler' },
    dollars = 19,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Hacca Howler gave chips with less than $20 held")
    end
}

Balatest.TestPlay {
    name = 'hacca_howler_gives_no_chips_in_debt',
    category = { 'jokers', 'the_jojolands', 'hacca_howler' },
    jokers = { 'j_jojoker_hacca_howler' },
    dollars = -40,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "Hacca Howler gave chips while in debt")
    end
}

Balatest.TestPlay {
    name = 'hacca_howler_uses_money_held_at_scoring_time',
    category = { 'jokers', 'the_jojolands', 'hacca_howler' },
    jokers = { 'j_jojoker_hacca_howler' },
    dollars = 0,
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.q(function()
            G.GAME.dollars = 40
            return true
        end)
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(7 + 7 + 2 * G.jokers.cards[1].ability.extra.chips_mod, "Hacca Howler did not track money held at scoring time")
    end
}

--#endregion
