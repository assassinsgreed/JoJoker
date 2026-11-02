from compendium.labels import Labels
from compendium.model import Joker
from compendium.synergy import build_relations, theme_index

D = Labels(
    themes={"luck": ("Luck", "Good things on a roll.")},
    similar={"card_preview": "Card preview"},
    conflicts={"repeats_tarot": "keeps offering your most-used tarot instead of new ones"},
)


def J(key, core=(), support=(), conflicts=None, similar=()):
    return Joker(key, key.replace("_", " ").title(), None, [], 1, 1, "Stand", None, "golden_wind", None,
                 themes_core=list(core), themes_support=list(support), conflicts=dict(conflicts or {}),
                 similar=list(similar))


def test_core_sees_everyone_support_sees_only_core():
    rel, errors, _ = build_relations([J("darby", core=["luck"]), J("star", support=["luck"]), J("atum", support=["luck"])], D)
    assert rel["darby"].synergies[0]["keys"] == ["star", "atum"]
    assert rel["star"].synergies[0]["keys"] == ["darby"]
    assert rel["star"].synergies[0]["name"] == "Luck"
    assert errors == []


def test_support_with_no_core_partner_has_no_block():
    rel, _, _ = build_relations([J("a", support=["luck"]), J("b", support=["luck"])], D)
    assert rel["a"].synergies == []


def test_conflict_appears_on_both_jokers_with_declarer_phrasing():
    rel, _, _ = build_relations([J("enya", conflicts={"the_world": "repeats_tarot"}), J("the_world")], D)
    reason = "Enya keeps offering your most-used tarot instead of new ones."
    assert rel["enya"].conflicts == [{"key": "the_world", "reason": reason}]
    assert rel["the_world"].conflicts == [{"key": "enya", "reason": reason}]


def test_similar_lists_other_members():
    rel, _, _ = build_relations([J("epitaph", similar=["card_preview"]), J("turbo_eyes", similar=["card_preview"])], D)
    assert rel["epitaph"].similar == [{"label": "Card preview", "keys": ["turbo_eyes"]}]


def test_errors():
    _, errors, _ = build_relations([
        J("a", core=["nope"]),
        J("b", conflicts={"ghost": "repeats_tarot"}),
        J("c", core=["luck"], conflicts={"d": "missing_reason"}),
        J("d", core=["luck"]),
    ], D)
    assert any("nope" in e for e in errors)
    assert any("ghost" in e for e in errors)
    assert any("missing_reason" in e for e in errors)
    assert any("c" in e and "d" in e and "synergy" in e for e in errors)


def test_small_theme_warns():
    _, _, warnings = build_relations([J("a", core=["luck"])], D)
    assert any("luck" in w for w in warnings)


def test_theme_index_lists_members_in_order():
    assert theme_index([J("darby", core=["luck"]), J("star", support=["luck"])], D) == [
        {"id": "luck", "name": "Luck", "blurb": "Good things on a roll.", "keys": ["darby", "star"]}
    ]
