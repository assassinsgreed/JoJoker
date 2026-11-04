# JoJoker (In Beta!)

A balatro mod that provides JoJo's Bizarre Adventure themed jokers, consumables, and more! Intended to fully replace vanilla content, but can be freely played alongside it and other mods.

This mod emphasizes fun and creativity first and foremost, with balance coming afterward.

See the [JoJoker Compendium](https://assassinsgreed.github.io/JoJoker/) for a list of content added by this game and example synergies.

## Installation

1. Make sure you have installed the latest release of both [Lovely](https://github.com/ethangreen-dev/lovely-injector) and [Steamodded](https://github.com/Steamopollys/Steamodded)
2. Download the desired release from the [Releases page](https://github.com/assassinsgreed/JoJoker/releases). If you want the latest, unreleased changes, download from the [latest commit](https://github.com/assassinsgreed/JoJoker/archive/refs/heads/main.zip)
3. Download the code and put it into your `Mods` folder
   1. This should look like `./Mods/JoJoker-1.0.0` if you took a release, with the specific version depending on the release chosen
   2. This should look like `./Mods/JoJoker-main` if you took the latest commit
4. Unzip the contents. You may delete the zip archive afterward
5. Make sure there is only one JoJoker in the folder structure. For example, if you pulled the latest release...
   1. `./Mods/JoJoker-main` is correct
   2. `./Modes/JoJoker/JoJoker-main` is incorrect
6. Start the game, configure JoJoker in the mods section, and have fun!

## Recommended Mods

These mods have integrations in JoJoker to enahnce the experience:

- [JokerDisplay](https://github.com/nh6574/JokerDisplay)

## Contributing

For developer resources, consult the [repo wiki](https://github.com/assassinsgreed/JoJoker/wiki). Feel free to open a PR with any bug fixes or feature improvements you'd like to see!

In the future, we'll look at other ways to get in touch, such as Discord.

### Compendium site

The [JoJoker Compendium](https://assassinsgreed.github.io/JoJoker/) documents every joker, with search, filters, similar jokers and example synergies. It is generated from the mod's own Lua and republished automatically whenever a GitHub Release is published (or manually from **Actions → Compendium → Run workflow**). The repository's **Settings → Pages → Source** must be set to **GitHub Actions** once.

To preview it locally:

```sh
python -m venv .venv
.venv/Scripts/python -m pip install -r compendium/requirements.txt   # .venv/bin/python on macOS/Linux
.venv/Scripts/python -m pytest -q
.venv/Scripts/python -m compendium.build
```

Then open `_site/index.html`. Synergy themes, similar-joker groups and conflicts live on each joker definition; see the `maintain-compendium` skill in `.claude/skills/` for how to classify new jokers.

## Credits

JoJokers is made and maintained by Assassins_Greed and PurpleHaunter.

This mod's concept and organization are heavily inspired by InertSteak's [Pokermon](https://github.com/InertSteak/Pokermon) project. Check them out!

JoJo's Bizarre Adventure is property of Hirohiko Araki.

## AI Usage Disclosure

Claude has been used to help me mechanically build and test jokers. This process was only utilized after creating 129 jokers by hand and learning the ins and outs of Balatro modding myself. AI has not and will never be used to generate art or design/balance game content; it is purely used to reduce repetition in the development process and minimize bugs.

# v0.1.0 TODOs Shortlist

- Add new title screen art
