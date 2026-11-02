from compendium.text import plain_description, render_description

KARS = [
    "Gains {X:mult,C:white} X#1# {} for each unique",
    "{C:planet}planet card{} played this game.",
    "{br:2}line break",
    "{C:inactive}Currently: {X:mult,C:white} X#2# {}",
]


def test_blocks_divider_and_flowing_text():
    html = render_description(KARS, ["2", "1"])
    assert html.count('<p class="ln">') == 2 and html.count('<hr class="div">') == 1
    assert "for each unique <span" in html


def test_xmult_highlight_wraps_value_only():
    html = render_description(KARS, ["2", "1"])
    assert 'Gains <span class="hl" style="background:#fe5f55;color:#ffffff">X2</span> for' in html


def test_missing_var_renders_question_mark():
    assert "X?" in render_description(KARS, ["2"])
    assert "X?" in render_description(KARS, None)


def test_html_is_escaped():
    assert "&lt;b&gt;" in render_description(['<b> & {C:mult}"x"{}'], [])
    assert "<b>" not in render_description(["<b>"], [])


def test_plain_text():
    assert plain_description(KARS, ["2", "1"]) == "Gains X2 for each unique planet card played this game. Currently: X1"
