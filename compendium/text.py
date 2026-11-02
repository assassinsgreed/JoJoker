import html
import re

LOC_COLOURS = {
    "mult": "#fe5f55", "red": "#fe5f55", "xmult": "#fe5f55", "chips": "#009dff", "blue": "#009dff",
    "money": "#d9a21b", "gold": "#d9a21b", "attention": "#ff9a00", "important": "#ff9a00", "filter": "#ff9a00",
    "edition": "#ff9a00", "tarot": "#a782d1", "planet": "#13afce", "spectral": "#4584fa", "inactive": "#9aa4a6",
    "green": "#4bc292", "purple": "#8867a5", "legendary": "#b26cbb", "dark_edition": "#5d5dff",
    "white": "#ffffff", "black": "#374244", "enhanced": "#8389dd", "hearts": "#f03464", "diamonds": "#f06b3f",
    "clubs": "#235955", "spades": "#403995",
}
DEFAULT_HIGHLIGHT = "#fe5f55"
TAG = re.compile(r"\{([^}]*)\}")
PLACEHOLDER = re.compile(r"#(\d+)#")


def fill(line: str, vars: list[str] | None) -> str:
    vars = vars or []
    return PLACEHOLDER.sub(lambda m: vars[int(m.group(1)) - 1] if int(m.group(1)) <= len(vars) else "?", line)


def blocks(lines: list[str]) -> list[list[str]]:
    result = [[]]
    for line in lines:
        if line.startswith("{br:"):
            result.append([])
        else:
            result[-1].append(line)
    return [b for b in result if b]


def parse_style(spec: str) -> dict[str, str]:
    style = {}
    for part in spec.split(","):
        key, _, value = part.partition(":")
        if value:
            style[key.strip()] = value.strip()
    return style


def styled(text: str, style: dict[str, str]) -> str:
    if not text:
        return ""
    if "X" not in style and "C" not in style:
        return html.escape(text)
    lead, core, trail = re.match(r"^(\s*)(.*?)(\s*)$", text, re.S).groups()
    if not core:
        return html.escape(text)
    if "X" in style:
        bg = LOC_COLOURS.get(style["X"], DEFAULT_HIGHLIGHT)
        fg = LOC_COLOURS.get(style.get("C", "white"), "#ffffff")
        span = f'<span class="hl" style="background:{bg};color:{fg}">{html.escape(core)}</span>'
    else:
        span = f'<span style="color:{LOC_COLOURS.get(style["C"], "inherit")}">{html.escape(core)}</span>'
    return html.escape(lead) + span + html.escape(trail)


def render_line(line: str) -> str:
    out, style, last = [], {}, 0
    for m in TAG.finditer(line):
        out.append(styled(line[last:m.start()], style))
        style = parse_style(m.group(1))
        last = m.end()
    out.append(styled(line[last:], style))
    return re.sub(r"\s{2,}", " ", "".join(out)).strip()


def render_description(lines: list[str], vars: list[str] | None) -> str:
    return '<hr class="div">'.join(
        '<p class="ln">' + render_line(" ".join(fill(l, vars) for l in block)) + "</p>" for block in blocks(lines)
    )


def plain_description(lines: list[str], vars: list[str] | None) -> str:
    text = " ".join(TAG.sub("", fill(l, vars)) for block in blocks(lines) for l in block)
    return re.sub(r"\s+", " ", text).strip()
