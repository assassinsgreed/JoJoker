(() => {
  const DATA = window.COMPENDIUM;
  const BY = Object.fromEntries(DATA.jokers.map(j => [j.key, j]));
  const $ = s => document.querySelector(s);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
  const el = (tag, cls, text) => { const e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = text; return e; };

  const SIZE = { 1: [71, 95], 2: [142, 190] };
  function spriteEl(j, scale) {
    const d = el("div", `sprite s${scale}x`);
    if (!j.sprite) { d.classList.add("blank"); return d; }
    const [x, y, part] = j.sprite, [w, h] = SIZE[scale];
    d.style.backgroundImage = `url(assets/${scale}x/AtlasJokers_${part}.png)`;
    d.style.backgroundPosition = `-${x * w}px -${y * h}px`;
    return d;
  }
  function miniEl(j) { const m = el("div", "mini"); m.append(spriteEl(j, 1)); return m; }

  const state = { q: "", part: "", type: "", rarity: "", theme: "" };
  const open = Object.fromEntries(Object.keys(DATA.types).map(t => [t, true]));
  const options = (sel, first, items) => { sel.innerHTML = `<option value="">${first}</option>` + items.map(([v, l]) => `<option value="${esc(v)}">${esc(l)}</option>`).join(""); };
  options($("#part"), "All parts", Object.entries(DATA.parts).map(([k, [n, name]]) => [k, `${n} · ${name}`]));
  options($("#type"), "All types", Object.keys(DATA.types).map(t => [t, t]));
  options($("#rarity"), "All rarities", Object.entries(DATA.rarities).map(([k, [name]]) => [k, name]));
  options($("#theme"), "Any", DATA.themes.map(t => [t.id, t.name]).sort((a, b) => a[1].localeCompare(b[1])));
  const themeKeys = Object.fromEntries(DATA.themes.map(t => [t.id, new Set(t.keys)]));

  $("#q").addEventListener("input", e => { state.q = e.target.value; render(); });
  for (const k of ["part", "type", "rarity", "theme"]) $("#" + k).addEventListener("change", e => { state[k] = e.target.value; render(); });
  $("#reset").addEventListener("click", () => { setFilters({}); });
  function setFilters(next) { Object.assign(state, { q: "", part: "", type: "", rarity: "", theme: "" }, next); $("#q").value = state.q; render(); }

  function matches(j) {
    if (state.part && j.part !== state.part) return false;
    if (state.type && j.type !== state.type) return false;
    if (state.rarity && String(j.rarity) !== state.rarity) return false;
    if (state.theme && !themeKeys[state.theme].has(j.key)) return false;
    return state.q.toLowerCase().split(/\s+/).filter(Boolean).every(w => j.search.includes(w));
  }

  function render() {
    for (const k of ["part", "type", "rarity", "theme"]) $("#" + k).value = state[k];
    const list = DATA.jokers.filter(matches);
    $("#count").textContent = `${list.length} of ${DATA.jokers.length} jokers`;
    $("#reset").hidden = !Object.values(state).some(Boolean);
    const root = $("#sections");
    root.replaceChildren();
    if (!list.length) { root.append(el("div", "empty", "No jokers match. Try clearing a filter.")); return; }
    for (const [type, [label, colour]] of Object.entries(DATA.types)) {
      const items = list.filter(j => j.type === type);
      if (!items.length) continue;
      const sec = el("details", "sec");
      sec.open = open[type];
      sec.style.setProperty("--tc", colour === "#f8f870" ? "#c8c808" : colour);
      const sum = el("summary", null, label + " ");
      sum.append(el("small", null, String(items.length)));
      sec.append(sum);
      sec.addEventListener("toggle", () => { open[type] = sec.open; });
      const grid = el("div", "grid");
      for (const j of items) {
        const b = el("button", "gcard");
        b.type = "button";
        b.append(spriteEl(j, 1), j.name);
        b.addEventListener("click", () => go(j.key));
        grid.append(b);
      }
      sec.append(grid);
      root.append(sec);
    }
  }

  const pill = (text, bg, fg, border) => `<span class="pill" style="background:${bg};color:${fg};border-color:${border || bg}">${esc(text)}</span>`;

  function mates(keys, reasons, current) {
    const box = el("div", "mates");
    for (const k of keys) {
      const o = BY[k];
      if (!o || k === current) continue;
      const m = el("button", "mate");
      m.type = "button";
      m.append(miniEl(o), o.name);
      const show = () => tipShow(m, o, reasons && reasons[k]);
      m.addEventListener("mouseenter", show);
      m.addEventListener("focus", show);
      m.addEventListener("mouseleave", tipHide);
      m.addEventListener("blur", tipHide);
      m.addEventListener("click", () => { tipHide(); go(k); });
      box.append(m);
    }
    return box.children.length ? box : null;
  }

  function section(title) { const s = el("div", "syn"); s.append(el("h3", null, title)); return s; }

  function show(key) {
    const j = BY[key];
    if (!j) { hideSheet(); return; }
    const [pn, pname, pbg, pfg] = DATA.parts[j.part] || ["?", "Unknown part", "#ccc", "#000"];
    const [, tbg, tfg, tborder] = DATA.types[j.type] || ["", "#ccc", "#000", "#ccc"];
    const [rname, rcol] = DATA.rarities[j.rarity] || ["Unknown", "#888"];
    const body = $("#body");
    body.innerHTML = `<div class="detail"><div class="big"></div><div class="info">
      <h2 id="sheet-title">${esc(j.name)}</h2>${j.alt ? `<div class="alt">Also known as: ${esc(j.alt)}</div>` : ""}
      <dl class="facts">
        <div><dt>Rarity</dt><dd>${pill(rname, rcol, "#fff")}</dd></div>
        <div><dt>Type</dt><dd>${pill(j.type, tbg, tfg, tborder)}</dd></div>
        <div><dt>Part</dt><dd>${pill(`${pn} · ${pname}`, pbg, pfg)}</dd></div>
        <div><dt>Cost</dt><dd class="money">$${j.cost}</dd></div>
      </dl>
      <div class="textbox">${j.html}</div></div></div>`;
    body.querySelector(".big").append(spriteEl(j, 2));

    if (j.similar.length) {
      const s = section("Similar jokers");
      for (const g of j.similar) {
        const ms = mates(g.keys, null, key);
        if (!ms) continue;
        const row = el("div", "simrow");
        row.append(el("div", "grp", g.label), ms);
        s.append(row);
      }
      body.append(s);
    }
    if (j.synergies.length) {
      const s = section("Example Synergies");
      for (const t of j.synergies) {
        const ms = mates(t.keys, null, key);
        if (!ms) continue;
        const box = el("div", "theme");
        const name = el("button", "tn", t.name);
        name.type = "button";
        name.addEventListener("click", () => { hideSheet(); setFilters({ theme: t.id }); });
        box.append(name, el("div", "tb", t.blurb), ms);
        s.append(box);
      }
      body.append(s);
    }
    if (j.conflicts.length) {
      const s = section("⚠ Works against");
      const box = el("div", "theme warnbox");
      const reasons = Object.fromEntries(j.conflicts.map(c => [c.key, c.reason]));
      for (const r of new Set(j.conflicts.map(c => c.reason))) box.append(el("div", "tb", r));
      const ms = mates(j.conflicts.map(c => c.key), reasons, key);
      if (ms) { ms.classList.add("warn"); box.append(ms); }
      s.append(box);
      body.append(s);
    }
    $("#sheet").hidden = false;
    $("#sheet").scrollTop = 0;
    document.body.style.overflow = "hidden";
  }

  function tipShow(anchor, o, reason) {
    const t = $("#tip");
    t.innerHTML = `<b>${esc(o.name)}</b>${reason ? `<div class="tipwarn">⚠ ${esc(reason)}</div>` : ""}<div class="textbox">${o.html}</div>`;
    t.hidden = false;
    const r = anchor.getBoundingClientRect(), tr = t.getBoundingClientRect();
    let top = r.top - tr.height - 8;
    if (top < 8) top = r.bottom + 8;
    t.style.top = Math.min(top, innerHeight - tr.height - 8) + "px";
    t.style.left = Math.max(8, Math.min(innerWidth - tr.width - 8, r.left)) + "px";
  }
  function tipHide() { $("#tip").hidden = true; }

  function hideSheet() {
    $("#sheet").hidden = true;
    tipHide();
    document.body.style.overflow = "";
    if (location.hash) history.pushState("", document.title, location.pathname + location.search);
  }
  function go(key) { if (location.hash !== "#" + key) location.hash = key; else show(key); }

  $("#close").addEventListener("click", hideSheet);
  $("#sheet").addEventListener("click", e => { if (e.target.id === "sheet") hideSheet(); });
  addEventListener("keydown", e => { if (e.key === "Escape" && !$("#sheet").hidden) hideSheet(); });
  addEventListener("hashchange", () => { const k = decodeURIComponent(location.hash.slice(1)); if (BY[k]) show(k); else { $("#sheet").hidden = true; tipHide(); document.body.style.overflow = ""; } });

  render();
  const initial = decodeURIComponent(location.hash.slice(1));
  if (BY[initial]) show(initial);
})();
