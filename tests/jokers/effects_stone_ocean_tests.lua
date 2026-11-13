--#region DIO's Bone

Balatest.TestPlay {
    name = 'dios_bone_counts_down_only_scored_cards',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone' },
    execute = function()
        Balatest.play_hand { '2S', '2C', '4D' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(extra.scored_cards_remaining, extra.card_threshold - 2, "DIO's Bone did not count down only scored cards")
    end
}

Balatest.TestPlay {
    name = 'dios_bone_does_not_count_retriggers',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone', 'j_jojoker_pucci' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(extra.scored_cards_remaining, extra.card_threshold - 1, "DIO's Bone counted a retriggered card more than once")
    end
}

Balatest.TestPlay {
    name = 'dios_bone_gives_xmult_when_threshold_reached',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(7 * G.jokers.cards[1].ability.extra.Xmult), "DIO's Bone did not give Xmult when the threshold was reached")
    end
}

Balatest.TestPlay {
    name = 'dios_bone_does_not_give_xmult_before_threshold',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7, "DIO's Bone gave Xmult before the threshold was reached")
    end
}

Balatest.TestPlay {
    name = 'dios_bone_carries_over_scored_cards_past_threshold',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone' },
    execute = function()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 1
        Balatest.play_hand { '2S', '2C' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(extra.scored_cards_remaining, extra.card_threshold - 1, "DIO's Bone did not carry over scored cards past the threshold")
    end
}

Balatest.TestPlay {
    name = 'dios_bone_only_gives_xmult_on_the_threshold_hand',
    category = { 'jokers', 'stone_ocean', 'dios_bone' },
    jokers = { 'j_jojoker_dios_bone' },
    execute = function()
        keep_blind_unbeaten()
        G.jokers.cards[1].ability.extra.scored_cards_remaining = 1
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(math.floor(7 * G.jokers.cards[1].ability.extra.Xmult) + 8, "DIO's Bone gave Xmult again on the hand after the threshold")
    end
}
--#endregion

--#region Snail
Balatest.TestPlay {
    name = 'snail_gains_chips_per_hand_played',
    category = { 'jokers', 'stone_ocean', 'snail' },
    jokers = { 'j_jojoker_snail' },
    execute = function()
        keep_blind_unbeaten()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        local extra = G.jokers.cards[1].ability.extra
        Balatest.assert_eq(extra.chips, extra.chips_mod * 2, "Snail did not gain chips for each hand played")
    end
}

Balatest.TestPlay {
    name = 'snail_scores_chips_gained_this_hand',
    category = { 'jokers', 'stone_ocean', 'snail' },
    jokers = { 'j_jojoker_snail' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 + G.jokers.cards[1].ability.extra.chips_mod, "Snail did not score the chips gained this hand")
    end
}

Balatest.TestPlay {
    name = 'snail_never_appears_in_the_joker_pool',
    category = { 'jokers', 'stone_ocean', 'snail' },
    execute = function() end,
    assert = function()
        Balatest.assert(not pool_offers('Joker', 'j_jojoker_snail', 'Common'), "Snail was offered in the joker pool")
    end
}
--#endregion
