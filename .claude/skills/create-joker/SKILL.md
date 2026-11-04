---
name: create-joker
description: Add a new Joker to the JoJoker Balatro mod. Use when asked to implement, add, or create a joker (or stand/character/effect card), or to wire up art that has already been dropped into a joker atlas. Covers the joker definition, sprite registration, joker order, JokerDisplay, localization, compendium synergies, and Balatest tests.
---

# Creating a JoJoker joker

A joker is not done until every file below is updated. Missing one leaves the joker
invisible, unnamed, or unsorted in game.

## Ask before building

Ask for clarification whenever the requested behavior is ambiguous — do not guess and
do not silently narrow the ask. Use `AskUserQuestion` with concrete options describing
what each choice would actually trigger in game. Common cases that need a question:

- The behavior has no direct Balatro/SMODS context (ex. "whenever a card is duplicated"),
  so the trigger scope has to be chosen.
- The spec could reasonably mean playing cards only, or playing cards plus jokers and
  consumables.
- Rarity, cost, or scaling numbers were not given and the balance is not obvious.
- The art slot in the atlas is ambiguous.

Ask before writing code, not after.

## 1. Locate the part and file

Jokers are grouped by JoJo part and by type:

`jokers/<characters|stands|effects>_<part>.lua`

Parts: `phantom_blood`, `battle_tendency`, `stardust_crusaders`, `diamond_is_unbreakable`,
`golden_wind`, `stone_ocean`, `steel_ball_run`, `jojolion`, `the_jojolands`.

## 2. Confirm the art slot

Art is usually already committed to `assets/1x/AtlasJokers_<part>.png` and the 2x copy.
Read the 1x atlas image to see where the new sprite sits. The grid is 5 columns wide,
71x95 per cell at 1x. Compare against the existing `functions/joker_sprite_load.lua`
entries for that part to derive the free `{x, y}`.

## 3. Joker definition

Append the joker before the `return` block and add it to the end of `list`.

```lua
local kiss = {
    name = "kiss",
    rarity = 1,
    cost = 5,
    jtype = "Stand",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 30, chips = 0 } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {center.ability.extra.chips_mod, center.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                colour = G.C.CHIPS,
                chip_mod = card.ability.extra.chips,
            }
        end
    end
}
```

- `name` is the snake_case key suffix; the registered key becomes `j_jojoker_<name>`.
- `rarity`: 1 Common, 2 Uncommon, 3 Rare, 4 Legendary.
- `jtype`: `Stand`, `Character`, or `Effect`.
- Permanently scaling values live in `config.extra` as a `<thing>_mod` / `<thing>` pair.
- Guard state-mutating branches with `not context.blueprint` so a copying joker cannot
  scale the original twice.
- Use `jojoker.debug` on branches that fire, matching the surrounding wording.
- `loc_vars` never picks a description key itself. `jojoker.load_joker` switches to the
  `_in_play` variant (section 7) for owned jokers and to `_alt` for localized names.
  Footer vars only render on an owned joker, so they must read truthfully mid-run (ex.
  `localize('none_used')` before anything has been tracked, never a stale default).
- Never declare helper functions as locals in the joker file. When logic is sizeable or
  complex, put it in `functions/jokerfunctions.lua` as a global (ex.
  `get_harvest_payout(card)`), so the joker, its JokerDisplay `calc_function`, and its
  tests all call the same code instead of duplicating the math. Small logic (ex. a
  one-line `next(SMODS.find_card(...))` check) stays inline where it is used, even in a
  lovely patch payload; it does not justify a new jokerfunction.

### Run-wide state

When the effect depends on something that happened before the joker was owned (ex.
"retroactive to the whole run"), track it in `G.GAME.jojoker_<thing>` from the mod-level
`SMODS.current_mod.calculate` in `jojoker.lua`, via a tracking helper in
`functions/jokerfunctions.lua`. Treat the field as `nil` until first set.

### Events that do not exist

If the behavior needs an event Balatro and SMODS do not provide, add it rather than
faking it in the joker:

1. A firing helper in `functions/jokerfunctions.lua` that calls
   `SMODS.calculate_context({ jojoker_<event> = true, card = card })`.
2. A hook in `lovely/gameplay_functions.toml` targeting the relevant game function,
   guarded with `if type(<helper>) == "function" then`.
3. Direct calls to the helper from any JoJoker joker that produces the same effect
   through a different path (ex. `SMODS.create_card` / `SMODS.add_card` instead of
   `copy_card`), so the event is complete rather than only covering vanilla.

Filter out the cases that are not really the event — previews, UI copies, conversions —
inside the helper, not inside each joker.

## 4. Register the sprite

`functions/joker_sprite_load.lua`, in the block for that part, in atlas order:

```lua
{name = "kiss", base = {pos = {x = 0, y = 3}}, part_atlas = "stone_ocean" },
```

## 5. Joker order

`functions/joker_order.lua` is grouped by `jtype` (`-- Characters`, `-- Effects`,
`-- Stands`, `-- Other`), alphabetical within each group; the in-game collection reads its
sections from it. Insert into the group matching the joker's `jtype`, not the whole list.

## 6. JokerDisplay

`jokerdisplay/<part>.lua`:

```lua
jd_def["j_jojoker_kiss"] = {
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "chips",  colour = G.C.CHIPS },
    },
}
```

Localization colour names are not `G.C` keys. `G.C.ATTENTION` does not exist, so it is
`nil` and renders white with no error, both here and in a `calculate` return's `colour`.
`{C:attention}` maps to `G.C.FILTER`. Match the colour other displays use for the same
kind of value (ex. `G.C.GREEN` for a `+N` size bonus like Oh Lonesome Me).

## 7. Localization

`localization/en-us.lua`, in the part's section, positioned to match the joker list order.

**Every joker with a real-world name has a localized (copyright-safe) alt name.** Give the
entry an `alt_name`; `jojoker.load_joker` swaps to it automatically when
`use_localized_names` is on. If you do not know the correct
alt name for that stand or character, ask — do not invent one.

```lua
j_jojoker_kiss = {
    name = "Kiss",
    alt_name = "Smack",
    text = {
        "Gains {C:chips}+#1#{} whenever a {C:attention}card{} is {C:attention}duplicated{}.",
    },
    in_play_text = {
        "{C:inactive}Currently: {C:chips}+#2#{}"
    }
},
```

Never write a `_alt` entry by hand: the loop at the bottom of `en-us.lua` generates
`j_jojoker_kiss_alt` from `alt_name`, sharing the base entry's `text`.

**Everything below the line break goes in `in_play_text`, never in `text`.** That means
every `Currently:`, `Remaining:`, `Chosen rank:`, `rounds left` or other status line, and
`text` itself never contains `{br:2}line break`. The base `text` is what the collection,
the shop and the compendium show, so it describes the effect alone. A loop at the bottom
of `en-us.lua` generates `j_jojoker_<name>_in_play` from `text`, a `{br:2}line break`,
then `in_play_text`. `jojoker.load_joker` uses that variant only while the card is in
`G.jokers`, then applies `_alt` on top. Never write an `_in_play` entry by hand.
Placeholder numbers are shared between `text` and `in_play_text`, so the `loc_vars` vars
list stays as it is.

**Keep descriptions short and sweet without losing clarity.** Use one strong verb instead
of a step-by-step account, and drop anything the `Currently:` footer or the colour codes
already say. Ex. "removes all extra chips and extra mult from scoring cards and adds them
to this Joker" becomes:

```lua
"Before scoring, drains all bonus {C:chips}chips{}",
"and {C:mult}mult{} from scoring cards.",
```

## 8. Compendium synergies

Every joker appears on the compendium site, so classify it before calling it done: give the
definition its `themes`, `similar` and `conflicts` fields (or deliberately none). Follow the
`maintain-compendium` skill, which walks through the classification checklist and the
verification commands. A joker with no real partners gets no fields; don't invent loose ones.

## 9. Tests

`tests/jokers/<same file name>_tests.lua`, in a `--#region <Joker Name>` block placed to
match the joker list order.

Never declare helper functions as locals in a test file. Put them in
`tests/testfunctions.lua` as globals (ex. `free_shop_items(area)`) so other tests can reuse
them; check that file for an existing helper before writing a new one.

**Never use an unmodded Balatro joker to set up a test.** Those jokers are not available
in a JoJoker run, so a test built on one proves nothing. Drive the scenario with JoJoker
jokers, with consumables, or by setting `ability.extra` directly in `execute`. Vanilla
consumables and enhancements are fine.

Cover the positive case, the per-occurrence case where the effect can fire more than once,
each distinct code path the effect reaches through, a negative case that should *not*
trigger it, and the scored result.

```lua
Balatest.TestPlay {
    name = 'kiss_gains_chips_when_a_playing_card_is_duplicated',
    category = { 'jokers', 'stone_ocean', 'kiss' },
    jokers = { 'j_jojoker_kiss', 'j_jojoker_german_engineering' },
    execute = function()
        Balatest.play_hand { '9S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.chips, G.jokers.cards[1].ability.extra.chips_mod, "Kiss did not gain chips when German Engineering duplicated a played card")
    end
}
```

Assert against `ability.extra` fields rather than hardcoded numbers where possible, so
rebalancing does not break tests. `Balatest.assert_chips` needs a literal, so compute it
from the hand: base hand chips + card nominals + joker contribution, times mult. Wrap it
in `math.floor` whenever the multiplier can be fractional, since the game floors the score
(ex. Caesar's X1.5 twice on 107 chips scores 240, not 240.75).

Useful Balatest settings: `jokers`, `consumeables`, `deck = { cards = {...} }`,
`hand_size`, `hands`, `discards`, `dollars`, `vouchers`, `seed`, `stake`. Useful actions:
`play_hand`, `highlight`, `use`, `discard`, `next_round`, `end_round`, `cash_out`, `buy`,
`sell`, `wait`.

### Hands that beat the blind

A hand that beats the blind ends the round, so end-of-round effects (resets, recoveries,
decay) fire before `assert` runs. When asserting on state that the round's end would
change, call `keep_blind_unbeaten()` at the start of `execute`. Assertions on
`G.GAME.chips` are unaffected.

### Small custom decks

**Never let a hand empty both the hand and the deck.** Vanilla ends the round when no
cards remain in either; with the blind unbeaten the run is lost and card areas are torn
down, so `assert` fails with errors like `attempt to index field 'discard' (a nil value)`.
Count every card the hand removes: played cards *and* any the joker discards, destroys,
or moves. Size the deck and `hand_size` so at least one card is left afterward, or play
the final hand only when the scenario expects the round to end.

When the joker picks a card at random, keep tests deterministic without relying on the
seed:

- Make every candidate identical (ex. five `4S`) and assert on totals across the deck.
- Use one distinguishing trait (ex. suit) to tell the played card from the affected one.
- For a scored result, play every card that could have been affected so the random
  pick is always counted (ex. `4S, 4H, 4C, 4D` as Four of a Kind after `next_round`).

## Comments

Match the codebase: comments are sparse. One short line above a `calculate` branch
explaining *why* it exists is the norm; a comment restating what the code does is not.
Names carry the documentation.
