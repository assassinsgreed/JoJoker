import argparse
import html
import json
import shutil
import sys
from pathlib import Path

from compendium.labels import LABELS
from compendium.lua_env import load_mod
from compendium.synergy import build_relations, theme_index
from compendium.text import plain_description, render_description

SITE_DIR = Path(__file__).parent / "site"

PARTS = {
    "phantom_blood": [1, "Phantom Blood", "#0a53a8", "#fff"],
    "battle_tendency": [2, "Battle Tendency", "#b10202", "#fff"],
    "stardust_crusaders": [3, "Stardust Crusaders", "#e6cff2", "#5a3286"],
    "diamond_is_unbreakable": [4, "Diamond is Unbreakable", "#ffc8aa", "#753800"],
    "golden_wind": [5, "Golden Wind", "#ffe5a0", "#473821"],
    "stone_ocean": [6, "Stone Ocean", "#e6e6e6", "#3d3d3d"],
    "steel_ball_run": [7, "Steel Ball Run", "#d4edbc", "#11734b"],
    "jojolion": [8, "JoJolion", "#bfe1f6", "#0a53a8"],
    "the_jojolands": [9, "The JOJOLands", "#3d3d3d", "#fff"],
}
TYPES = {
    "Character": ["Characters", "#c03030", "#fff", "#c03030"],
    "Effect": ["Effects", "#f8f870", "#4a4600", "#c8c808"],
    "Stand": ["Stands", "#4840c8", "#fff", "#4840c8"],
}
RARITIES = {1: ["Common", "#009dff"], 2: ["Uncommon", "#4bc292"], 3: ["Rare", "#fe5f55"], 4: ["Legendary", "#b26cbb"]}


class BuildError(Exception):
    pass


def ensure_safe_output(root: Path, out: Path) -> None:
    root, out = root.resolve(), out.resolve()
    if out == root or out in root.parents:
        raise BuildError(f"refusing to clear {out}: it contains the mod")


def joker_record(joker, relations) -> dict:
    rel = relations[joker.key]
    plain = plain_description(joker.text, joker.vars)
    return {
        "key": joker.key,
        "name": joker.name,
        "alt": joker.alt_name,
        "rarity": joker.rarity,
        "cost": joker.cost,
        "type": joker.jtype,
        "part": joker.part,
        "sprite": list(joker.sprite) if joker.sprite else None,
        "html": render_description(joker.text, joker.vars),
        "search": " ".join([joker.name, joker.alt_name or "", plain]).lower(),
        "similar": rel.similar,
        "synergies": rel.synergies,
        "conflicts": rel.conflicts,
    }


def build_site(root: Path, out: Path, version: str) -> list[str]:
    ensure_safe_output(root, out)
    mod = load_mod(root)
    relations, errors, warnings = build_relations(mod.jokers, LABELS)
    if errors:
        raise BuildError("\n".join(errors))
    data = {
        "version": version,
        "jokers": [joker_record(j, relations) for j in mod.jokers],
        "themes": theme_index(mod.jokers, LABELS),
        "parts": PARTS,
        "types": TYPES,
        "rarities": RARITIES,
    }
    if out.exists():
        shutil.rmtree(out)
    shutil.copytree(SITE_DIR, out)
    index = out / "index.html"
    index.write_text(index.read_text(encoding="utf8").replace("{{VERSION}}", html.escape(version)), encoding="utf8")
    (out / "data.js").write_text("window.COMPENDIUM = " + json.dumps(data, ensure_ascii=False) + ";\n", encoding="utf8")
    for scale in ("1x", "2x"):
        target = out / "assets" / scale
        target.mkdir(parents=True)
        for atlas in (root / "assets" / scale).glob("AtlasJokers_*.png"):
            shutil.copy(atlas, target)
    return mod.warnings + warnings


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Build the JoJoker compendium site")
    parser.add_argument("--version", default="dev")
    parser.add_argument("--out", default="_site")
    args = parser.parse_args(argv)
    root = Path(__file__).resolve().parent.parent
    try:
        warnings = build_site(root, root / args.out, args.version)
    except BuildError as e:
        print(f"Build failed:\n{e}", file=sys.stderr)
        return 1
    for w in warnings:
        print(f"warning: {w}")
    print(f"Built {root / args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
