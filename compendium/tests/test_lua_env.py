from compendium.lua_env import order_jokers
from compendium.model import Joker


def find(mod, key):
    return next(j for j in mod.jokers if j.key == key)


def test_loads_every_joker(mod):
    assert len(mod.jokers) == 171


def test_order_is_collection_order(mod):
    types = [j.jtype for j in mod.jokers]
    assert types == sorted(types, key=["Character", "Effect", "Stand"].index)
    assert mod.jokers[0].key == "angelo"


def test_aerosmith_fields(mod):
    j = find(mod, "aerosmith")
    assert (j.name, j.alt_name, j.jtype, j.part, j.rarity) == ("Aerosmith", "Li'l Bomber", "Stand", "golden_wind", 3)
    assert j.text[0] == "If played hand is a {C:attention}High Card{}, gives"


def test_sprite(mod):
    assert find(mod, "danny").sprite == (0, 0, "phantom_blood")


def test_escaped_quotes_survive(mod):
    assert find(mod, "john_rod").name == '"John Rod"'


def test_no_alt_duplicates(mod):
    assert not any(j.key.endswith("_alt") for j in mod.jokers)


def test_unordered_joker_appended_to_its_type_group():
    warnings = []
    a, b, c = (Joker(k, k, None, [], 1, 1, t, None, "phantom_blood", None)
               for k, t in [("a", "Character"), ("b", "Stand"), ("c", "Character")])
    assert [j.key for j in order_jokers([a, b, c], ["a", "b"], warnings)] == ["a", "c", "b"]
    assert any("c" in w for w in warnings)
