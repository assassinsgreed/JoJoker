---
name: create-joker
description: Add a new Joker to the JoJoker Balatro mod. Use when asked to implement, add, or create a joker (or stand/character/effect card), or to wire up art that has already been dropped into a joker atlas. Covers the joker definition, sprite registration, joker order, JokerDisplay, localization, and Balatest tests.
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
    jclass = "Close Range",
    part = "stone_ocean",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips_mod = 30, chips = 0 } },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {center.ability.extra.chips_mod, center.ability.extra.chips},
            key = jojoker_config.use_localized_names and self.key..'_alt' or self.key
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
- `jtype`: `Stand`, `Character`, or `Effect`. `jclass` (stands only): `Close Range`,
  `Long Range`, or `Automatic`.
- Permanently scaling values live in `config.extra` as a `<thing>_mod` / `<thing>` pair.
- Guard state-mutating branches with `not context.blueprint` so a copying joker cannot
  scale the original twice.
- Use `sendDebugMessage` on branches that fire, matching the surrounding wording.

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

`functions/joker_order.lua` is one flat alphabetical list of `name` values. Insert in the
correct alphabetical position.

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

## 7. Localization

`localization/en-us.lua`, in the part's section, positioned to match the joker list order.

**Every joker with a real-world name has a localized (copyright-safe) alt name.** Write
both entries and have `loc_vars` return the `_alt` key via the
`jojoker_config.use_localized_names` pattern shown above. If you do not know the correct
alt name for that stand or character, ask — do not invent one.

```lua
j_jojoker_kiss = {
    name = "Kiss",
    text = {
        "Gains {C:chips}+#1#{} whenever a {C:attention}card{} is {C:attention}duplicated{}.",
        "{br:2}line break",
        "{C:inactive}Currently: {C:chips}+#2#{}"
    }
},
j_jojoker_kiss_alt = {
    name = "Smack",
    text = {
        "Gains {C:chips}+#1#{} whenever a {C:attention}card{} is {C:attention}duplicated{}.",
        "{br:2}line break",
        "{C:inactive}Currently: {C:chips}+#2#{}"
    }
},
```

Both entries carry identical `text`; only `name` differs. Scaling jokers end with the
`{br:2}line break` / `{C:inactive}Currently:` footer.

## 8. Tests

`tests/jokers/<same file name>_tests.lua`, in a `--#region <Joker Name>` block placed to
match the joker list order.

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
from the hand: base hand chips + card nominals + joker contribution, times mult.

Useful Balatest settings: `jokers`, `consumeables`, `deck = { cards = {...} }`, `hands`,
`discards`, `dollars`, `vouchers`, `seed`, `stake`. Useful actions: `play_hand`,
`highlight`, `use`, `discard`, `next_round`, `end_round`, `cash_out`, `buy`, `sell`,
`wait`.

## Comments

Match the codebase: comments are sparse. One short line above a `calculate` branch
explaining *why* it exists is the norm; a comment restating what the code does is not.
Names carry the documentation.
