import pytest

from compendium.labels import LABELS
from compendium.synergy import build_relations


@pytest.fixture(scope="module")
def rel(mod):
    return build_relations(mod.jokers, LABELS)


def partners(rel, key):
    return {s["name"]: s["keys"] for s in rel[0][key].synergies}


def flat(d):
    return {k for keys in d.values() for k in keys}


def against(rel, key):
    return {c["key"] for c in rel[0][key].conflicts}


def test_mod_data_is_valid(rel):
    assert rel[1] == []


def test_suits_and_retriggers_stay_specific(rel):
    assert partners(rel, "leaky_eye_luca") == {"Spades": ["ndoul", "white_snake"]}
    assert "seven_page_muda" not in flat(partners(rel, "yellow_temperance"))
    assert "stone_free" not in flat(partners(rel, "yellow_temperance"))


def test_conflicts_are_pairwise_and_two_sided(rel):
    assert against(rel, "enya") == {"the_world"}
    assert "killer_queen" in against(rel, "ghost_girl_alley") and "ghost_girl_alley" in against(rel, "killer_queen")
    assert "thunder_cross_split_attack" in against(rel, "red_hot_chili_pepper")
    assert "red_hot_chili_pepper" in against(rel, "thunder_cross_split_attack")
    assert "marilyn_manson" not in against(rel, "red_hot_chili_pepper")


def test_review_round_synergies(rel):
    assert "yoshikage_kira" in flat(partners(rel, "made_in_heaven"))
    assert "stroheim_german_engineering" in flat(partners(rel, "killer_queen"))
    assert "paper_moon_king" in flat(partners(rel, "tequila_joseph"))
    assert "tomb_of_the_boom" in flat(partners(rel, "tattoo_you"))
    assert {"paisley_park", "thoth"} <= flat(partners(rel, "the_world"))
    assert {"paisley_park", "in_a_silent_way"} <= flat(partners(rel, "smokey"))


def test_similar_groups(rel):
    assert [s["keys"] for s in rel[0]["epitaph"].similar] == [["turbo_eyes"]]
    assert rel[0]["khnum"].similar[0]["keys"] == ["surface"]


def test_counts_match_themes_doc(mod):
    themes = {t for j in mod.jokers for t in j.themes_core + j.themes_support}
    assert len(themes) == 52
    assert sum(len(j.conflicts) for j in mod.jokers) == 74
    assert len({g for j in mod.jokers for g in j.similar}) == 26
