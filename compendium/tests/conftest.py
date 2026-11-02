from pathlib import Path

import pytest

from compendium.lua_env import load_mod

REPO_ROOT = Path(__file__).resolve().parents[2]


@pytest.fixture(scope="session")
def mod():
    return load_mod(REPO_ROOT)
