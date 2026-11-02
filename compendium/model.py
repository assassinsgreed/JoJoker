from dataclasses import dataclass, field


@dataclass
class Joker:
    key: str
    name: str
    alt_name: str | None
    text: list[str]
    rarity: int
    cost: int
    jtype: str
    part: str
    sprite: tuple[int, int, str] | None
    vars: list[str] | None = None
    themes_core: list[str] = field(default_factory=list)
    themes_support: list[str] = field(default_factory=list)
    conflicts: dict[str, str] = field(default_factory=dict)
    similar: list[str] = field(default_factory=list)


@dataclass
class Mod:
    jokers: list[Joker]
    warnings: list[str] = field(default_factory=list)
