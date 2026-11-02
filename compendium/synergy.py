from dataclasses import dataclass, field

from compendium.labels import Labels
from compendium.model import Joker


@dataclass
class Relations:
    similar: list[dict] = field(default_factory=list)
    synergies: list[dict] = field(default_factory=list)
    conflicts: list[dict] = field(default_factory=list)


def theme_members(jokers: list[Joker]) -> dict[str, tuple[list[str], list[str]]]:
    members: dict[str, tuple[list[str], list[str]]] = {}
    for j in jokers:
        for theme in j.themes_core:
            members.setdefault(theme, ([], []))[0].append(j.key)
        for theme in j.themes_support:
            members.setdefault(theme, ([], []))[1].append(j.key)
    return members


def theme_text(labels: Labels, theme: str) -> tuple[str, str]:
    return labels.themes.get(theme, (theme, ""))


def theme_index(jokers: list[Joker], labels: Labels) -> list[dict]:
    order = {j.key: i for i, j in enumerate(jokers)}
    return [
        {
            "id": theme,
            "name": theme_text(labels, theme)[0],
            "blurb": theme_text(labels, theme)[1],
            "keys": sorted(core + support, key=order.get),
        }
        for theme, (core, support) in theme_members(jokers).items()
    ]


def build_relations(jokers: list[Joker], labels: Labels) -> tuple[dict[str, Relations], list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []
    by_key = {j.key: j for j in jokers}
    order = {j.key: i for i, j in enumerate(jokers)}
    in_order = lambda keys: sorted(keys, key=order.get)
    members = theme_members(jokers)
    relations = {j.key: Relations() for j in jokers}

    for theme, (core, support) in members.items():
        if theme not in labels.themes:
            errors.append(f"unknown theme '{theme}' used by {', '.join(core + support)}")
        elif len(core) + len(support) < 2:
            warnings.append(f"theme '{theme}' has fewer than two jokers")

    for j in jokers:
        for theme in j.themes_core + j.themes_support:
            core, support = members[theme]
            partners = core + support if theme in j.themes_core else core
            keys = in_order(k for k in set(partners) if k != j.key)
            if keys:
                relations[j.key].synergies.append({
                    "id": theme,
                    "name": theme_text(labels, theme)[0],
                    "blurb": theme_text(labels, theme)[1],
                    "keys": keys,
                })

    groups: dict[str, list[str]] = {}
    for j in jokers:
        for group in j.similar:
            groups.setdefault(group, []).append(j.key)
    for group, keys in groups.items():
        label = labels.similar.get(group)
        if label is None:
            errors.append(f"unknown similar group '{group}' used by {', '.join(keys)}")
            continue
        for key in keys:
            others = [k for k in keys if k != key]
            if others:
                relations[key].similar.append({"label": label, "keys": others})

    for j in jokers:
        for other, reason_id in j.conflicts.items():
            reason = labels.conflicts.get(reason_id)
            if other not in by_key:
                errors.append(f"{j.key} conflicts with unknown joker '{other}'")
                continue
            linked = any(other in s["keys"] for s in relations[j.key].synergies) or \
                any(j.key in s["keys"] for s in relations[other].synergies)
            if linked:
                errors.append(f"{j.key} and {other} are listed as both a synergy and a conflict")
            if reason is None:
                errors.append(f"{j.key} uses unknown conflict reason '{reason_id}'")
                continue
            text = f"{j.name} {reason}."
            relations[j.key].conflicts.append({"key": other, "reason": text})
            relations[other].conflicts.append({"key": j.key, "reason": text})

    for rel in relations.values():
        rel.conflicts.sort(key=lambda c: order[c["key"]])
    return relations, errors, warnings
