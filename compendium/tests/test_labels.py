from compendium.labels import LABELS
from compendium.lua_env import new_runtime, run_file
from compendium.tests.conftest import REPO_ROOT


def test_game_localization_has_no_compendium_text():
    loc = run_file(new_runtime(REPO_ROOT), REPO_ROOT / "localization" / "en-us.lua")
    keys = list(loc.misc.dictionary.keys())
    assert not [k for k in keys if k.startswith(("jojoker_theme_", "jojoker_similar_", "jojoker_conflict_"))]


def test_labels_cover_the_mod_data(mod):
    assert {t for j in mod.jokers for t in j.themes_core + j.themes_support} <= set(LABELS.themes)
    assert {g for j in mod.jokers for g in j.similar} <= set(LABELS.similar)
    assert {r for j in mod.jokers for r in j.conflicts.values()} <= set(LABELS.conflicts)
    assert LABELS.themes["luck"] == ("Luck", "Good things on a roll. Darby Brothers doubles every one of these odds.")
