from compendium.lua_env import eval_loc_vars, new_runtime
from compendium.tests.conftest import REPO_ROOT


def vars_of(mod, key):
    return next(j for j in mod.jokers if j.key == key).vars


def test_simple_vars(mod):
    assert vars_of(mod, "star_platinum") == ["1", "4"]
    assert vars_of(mod, "danny") == ["15"]


def test_numbers_format_like_the_game(mod):
    assert vars_of(mod, "aerosmith") == ["0.5"]
    assert vars_of(mod, "kars_ultimate_lifeform") == ["2", "5", "1", "5"]


def test_erroring_loc_vars_returns_none_and_warns():
    lua = new_runtime(REPO_ROOT)
    item = lua.eval("{ name = 'boom', config = { extra = {} }, loc_vars = function() error('kaput') end }")
    warnings = []
    assert eval_loc_vars(lua, item, warnings) is None
    assert any("boom" in w for w in warnings)


def test_live_state_jokers_do_not_crash(mod):
    for key in ["old_joseph_joestar", "wamuu", "ghost_girl_alley", "goo_goo_dolls", "harvest", "white_album"]:
        v = vars_of(mod, key)
        assert v is None or all(isinstance(x, str) and x for x in v), key
