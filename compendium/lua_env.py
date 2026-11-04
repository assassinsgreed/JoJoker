from pathlib import Path

from lupa.luajit21 import LuaRuntime

from compendium.model import Joker, Mod

TYPE_ORDER = ["Character", "Effect", "Stand"]

STUBS = """
SMODS = { Atlas = function() end, Joker = function() end, current_mod = { config = {} } }
sendDebugMessage = function() end
jojoker = {}
G = {
    GAME = { probabilities = { normal = 1 }, starting_deck_size = 52, hands = {} },
    C = setmetatable({}, { __index = function() return {} end }),
    P_CENTERS = setmetatable({}, { __index = function() return {} end }),
}

local function copy(t)
    if type(t) ~= "table" then return t end
    local r = {}
    for k, v in pairs(t) do r[k] = copy(v) end
    return r
end

function compendium_loc_vars(item)
    if not item.loc_vars then return true, {}, 0 end
    local card = { ability = copy(item.config or {}), config = { center = item } }
    card.ability.extra = card.ability.extra or {}
    local ok, res = pcall(item.loc_vars, item, {}, card)
    if not ok then return false, tostring(res), 0 end
    local vars = (res and res.vars) or {}
    return true, vars, table.maxn(vars)
end
"""


def format_var(value) -> str:
    if value is None:
        return "?"
    if isinstance(value, bool):
        return str(value).lower()
    if isinstance(value, float):
        return str(int(value)) if value.is_integer() else format(value, ".15g")
    return str(value)


def eval_loc_vars(lua: LuaRuntime, item, warnings: list[str]) -> list[str] | None:
    ok, vars, count = lua.globals().compendium_loc_vars(item)
    if not ok:
        warnings.append(f"{item.name}: loc_vars failed ({vars}); placeholders will show '?'")
        return None
    return [format_var(vars[i]) for i in range(1, int(count) + 1)]


def read(path: Path) -> str:
    return path.read_text(encoding="utf8")


def run_file(lua: LuaRuntime, path: Path):
    chunk = lua.globals().load(read(path), "@" + path.name)
    return chunk()


def new_runtime(root: Path) -> LuaRuntime:
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.globals().SMODS.current_mod.path = str(root) + "/"
    for name in ["joker_order.lua", "themes.lua", "joker_sprite_load.lua", "jokerfunctions.lua"]:
        run_file(lua, root / "functions" / name)
    return lua


def lua_list(table) -> list:
    if table is None:
        return []
    return [table[i] for i in range(1, len(table) + 1)]


def load_localization(lua: LuaRuntime, root: Path):
    loc = run_file(lua, root / "localization" / "en-us.lua")
    dictionary = {k: v for k, v in loc.misc.dictionary.items() if isinstance(v, str)}
    lua.globals().localize = lambda key, *_: dictionary.get(key, key)
    return loc.descriptions.Joker


def load_sprites(lua: LuaRuntime) -> dict[str, tuple[int, int, str]]:
    sprites = {}
    for entry in lua_list(lua.globals().JokerSprites.list):
        pos = entry.base.pos
        if pos.x is not None:
            sprites[entry.name] = (int(pos.x), int(pos.y), entry.part_atlas)
    return sprites


def to_joker(item, loc_jokers, sprites) -> Joker:
    key = item.name
    loc = loc_jokers["j_jojoker_" + key]
    return Joker(
        key=key,
        name=loc.name if loc else key,
        alt_name=loc.alt_name if loc else None,
        text=lua_list(loc.text) if loc else [],
        rarity=int(item.rarity),
        cost=int(item.cost),
        jtype=item.jtype,
        part=item.part,
        sprite=sprites.get(key),
        themes_core=lua_list(item.themes and item.themes.core),
        themes_support=lua_list(item.themes and item.themes.support),
        conflicts=dict(item.conflicts.items()) if item.conflicts else {},
        similar=lua_list(item.similar),
    )


def order_jokers(jokers: list[Joker], order: list[str], warnings: list[str]) -> list[Joker]:
    rank = {key: i for i, key in enumerate(order)}
    for j in jokers:
        if j.key not in rank:
            warnings.append(f"{j.key} is missing from joker_order.lua; appended to its type group")
    type_rank = lambda j: TYPE_ORDER.index(j.jtype) if j.jtype in TYPE_ORDER else len(TYPE_ORDER)
    return sorted(jokers, key=lambda j: (type_rank(j), rank.get(j.key, len(order))))


def load_mod(root: Path) -> Mod:
    lua = new_runtime(root)
    loc_jokers = load_localization(lua, root)
    sprites = load_sprites(lua)
    warnings: list[str] = []
    jokers = []
    for path in sorted((root / "jokers").glob("*.lua")):
        for item in lua_list(run_file(lua, path).list):
            joker = to_joker(item, loc_jokers, sprites)
            joker.vars = eval_loc_vars(lua, item, warnings)
            jokers.append(joker)
    order = lua_list(lua.globals().jojoker.joker_order)
    return Mod(jokers=order_jokers(jokers, order, warnings), warnings=warnings)
