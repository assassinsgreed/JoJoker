---
name: maintain-compendium
description: Use when a JoJoker joker is added, removed, or has its effect changed; when deciding a joker's synergy themes, similar jokers, or conflicts; when a new theme, similar group or conflict reason is needed; when the compendium build or its tests fail; or when consumables, vouchers, challenges or other new content should appear on the compendium site.
---

# Maintaining the JoJoker Compendium

## Overview

The compendium site (`compendium/`, published to GitHub Pages on each GitHub Release) is generated entirely from the mod's Lua. Nothing is maintained by hand outside the mod source: if a joker's data is wrong in code, it is wrong on the site.

The pop-up exists for one journey: a player likes a joker, finds partners toward different playstyles, and discovers synergies they hadn't considered. **A loose suggestion is worse than none.**

## Where the data lives

| Data | Location |
|---|---|
| Name, alt name, effect text | `localization/en-us.lua` → `descriptions.Joker.j_jojoker_<key>` |
| Rarity, cost, type, class, part, `loc_vars` numbers | the joker definition in `jokers/*.lua` |
| Sprite | `functions/joker_sprite_load.lua` |
| Order | `functions/joker_order.lua` |
| Theme and similar-group ids | `functions/themes.lua` (`jojoker.themes`, `jojoker.similar`) |
| A joker's themes, similar groups, conflicts | fields on the joker definition (below) |
| Theme name and blurb, similar-group label, conflict reason text | `compendium/labels.py` (`LABELS.themes`, `.similar`, `.conflicts`) |

Site-only text lives in `compendium/labels.py`, never in `localization/en-us.lua`: the game loads that file, and the compendium is a separate resource. A test fails if compendium text appears there.

```lua
part = "golden_wind",
themes = { core = { jojoker.themes.STONE_STEEL_EATER }, support = { jojoker.themes.LUCK } },
conflicts = { caesar = "strips_the_stone_cards_these", stone_free = "strips_the_stone_cards_these" },
similar = { jojoker.similar.ENHANCEMENT_STRIPPERS },
```

All three fields are optional; the game ignores them. Place them right after `part`.

## How synergies display

- **Core** jokers pair with every joker in the theme. **Support** jokers pair only with the core, never with each other. Roles are never shown on the page.
  - Luck: Darby Brothers is core, chance jokers are support, so Star Platinum and Atum are not suggested together.
- A **theme blurb** reads as a playstyle and names who feeds whom.
- A **conflict** is declared once, on the joker that does the harm, keyed by the other joker. The reason text completes "`<Declaring joker name> <reason>.`" (e.g. `keeps offering your most-used tarot instead of new ones`). Both pop-ups show it.
- **Similar jokers** are near-duplicates (Epitaph / Turbo Eyes, Khnum / Surface), not combos.

## Classification checklist

Work through every item for each new or changed joker:

1. **The rule:** two jokers share a theme only if one directly feeds the other, or both reward the exact same play. Ask: "If a player picked these two up together, would they be glad they did?"
2. **Consumes and produces:** a joker that converts a resource into value (XMult per lost hand, per sell value, per destroyed card) pairs with everything that adds that resource. Made in Heaven gains for each hand it removes, so +hands jokers feed it.
3. **Deck conversions:** jokers that turn many cards into one rank or suit pair with jokers that reward a uniform deck (Pareidolia + Tequila Joseph = all Queens; Tattoo You + Tomb of the Boom = a hand full of Jacks).
4. **Triggers vs side effects:** if a joker causes an event (rewind, skip, destroy, extra rounds), check every joker that reacts to it. Feeds it → synergy (Killer Queen gives Stroheim (German Engineering) more blinds). Triggers its penalty → conflict (a rewound ante destroys Ghost Girl Alley).
5. **Using consumables is not holding them:** slot effects (Negative, empty slots) matter only to jokers that care about held consumables. Jokers counting cards used (The World, Kars) pair with ways to find more (Paisley Park, Thoth).
6. **Shop and pack effects reinforce each other** (Paisley Park, Thoth, Smokey, In a Silent Way). Loose is fine if a player would plausibly build it.
7. **Specific beats generic:** rank-, suit- or card-specific jokers pair only when they hit the same cards (Yellow Temperance + Jumpin' Jack Flash both hit Jacks; Yellow Temperance + Seven Page Muda don't).
8. **No partner lists for jokers that help everything that scores** (generic retriggers, flat boosts, copy jokers). Retriggers pair only with other retriggers.
9. **A conflict needs active harm:** destroying, resetting, spending, stripping or debuffing what the other needs. Merely *allowing* something (Marilyn Manson allows debt) is not a conflict.
10. **Never both:** a pair that conflicts must not also be linked by a theme. The build fails if it is.
11. **No partner? No fields.** A joker with no real synergy gets no `themes`, which is better than a weak one.

When a joker needs a new theme, add the enum entry in `functions/themes.lua` and its name and blurb in `compendium/labels.py`, and check the theme has at least two jokers (the build warns otherwise). Prefer splitting a theme over loosening one.

When a conflict needs a reason no existing `LABELS.conflicts` entry covers, add one: a short snake_case id and lowercase text with no joker name and no trailing full stop. Reuse an existing reason when the wording fits.

## Verify

```sh
.venv/Scripts/python -m pytest -q          # compendium/tests; README has venv setup
.venv/Scripts/python -m compendium.build   # writes _site/; fails on unknown ids or synergy/conflict overlap
```

Open `_site/index.html#<joker_key>` and read the pop-up: similar jokers, every Example Synergies block, and ⚠ Works against. Then open each listed partner and confirm the pairing reads correctly from its side too.

`compendium/tests/test_mod_data.py` pins past review decisions and the theme/conflict/similar counts. When you deliberately change the data, update those assertions in the same change.

## Adding a new content type (consumables, vouchers, challenges…)

1. Load it in `compendium/lua_env.py` (run its definition files with the existing stubs; add stubs as load errors require) into a new dataclass in `compendium/model.py`.
2. Emit it as a new top-level list in `data.js` from `compendium/build.py`, with tests in `compendium/tests/`.
3. Add a content tab bar to `compendium/site/index.html` and render the new list in `app.js`. The tab bar appears only once there are two or more content types.

## Common mistakes

| Mistake | Fix |
|---|---|
| Putting two support jokers in a theme with no core | They'll show no partners; one must be core, or they need a different theme |
| Listing a conflict per theme | Conflicts are joker-vs-joker; list each affected joker |
| Writing the joker's name inside the conflict reason | The site prepends the declaring joker's name |
| Adding a `_alt` localization entry by hand | It's generated from `alt_name` |
| Editing `_site/` | It's build output; change the Lua or `compendium/site/` instead |
