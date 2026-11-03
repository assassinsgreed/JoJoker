import json
import re

import pytest

from compendium.build import BuildError, build_site, ensure_safe_output
from compendium.tests.conftest import REPO_ROOT


@pytest.fixture(scope="module")
def site(tmp_path_factory):
    out = tmp_path_factory.mktemp("site")
    build_site(REPO_ROOT, out, "v9.9.9")
    return out


@pytest.fixture(scope="module")
def data(site):
    text = (site / "data.js").read_text(encoding="utf8").strip()
    assert text.startswith("window.COMPENDIUM = ") and text.endswith(";")
    return json.loads(text[len("window.COMPENDIUM = "):-1])


def test_outputs_exist(site):
    for f in ["index.html", "style.css", "app.js", "data.js",
              "assets/1x/AtlasJokers_golden_wind.png", "assets/2x/AtlasJokers_golden_wind.png"]:
        assert (site / f).exists(), f


def test_data_has_every_joker(data):
    assert len(data["jokers"]) == 157 and data["version"] == "v9.9.9"
    assert len(data["themes"]) == 50


def test_search_text_includes_alt_name_lowercased(data):
    aero = next(j for j in data["jokers"] if j["key"] == "aerosmith")
    assert "li'l bomber" in aero["search"] and "high card" in aero["search"]


def test_joker_record_shape(data):
    world = next(j for j in data["jokers"] if j["key"] == "the_world")
    assert (world["type"], world["part"], world["rarity"]) == ("Stand", "stardust_crusaders", 4)
    assert world["sprite"] == [4, 1, "stardust_crusaders"]
    assert '<hr class="div">' in world["html"]
    assert {c["key"] for c in world["conflicts"]} == {"enya"}


def test_no_raw_placeholders(data):
    assert not [j["key"] for j in data["jokers"] if re.search(r"#\d+#", j["html"])]


def test_version_is_escaped(tmp_path):
    build_site(REPO_ROOT, tmp_path, "v1<script>")
    html = (tmp_path / "index.html").read_text(encoding="utf8")
    assert "v1&lt;script&gt;" in html and "v1<script>" not in html


def test_relation_errors_fail_the_build(tmp_path, monkeypatch):
    monkeypatch.setattr("compendium.build.build_relations", lambda *a: ({}, ["boom"], []))
    with pytest.raises(BuildError):
        build_site(REPO_ROOT, tmp_path, "dev")


def test_output_dir_may_not_contain_the_repo(tmp_path):
    repo = tmp_path / "repo"
    for out in (repo, tmp_path):
        with pytest.raises(BuildError):
            ensure_safe_output(repo, out)
    ensure_safe_output(repo, repo / "_site")


def test_page_shell(site):
    html = (site / "index.html").read_text(encoding="utf8")
    for needle in ['id="q"', 'id="part"', 'id="type"', 'id="rarity"', 'id="theme"', 'id="sheet"', "data.js", "app.js"]:
        assert needle in html
    app = (site / "app.js").read_text(encoding="utf8")
    assert "Example Synergies" in app and "Similar jokers" in app and "Works against" in app
