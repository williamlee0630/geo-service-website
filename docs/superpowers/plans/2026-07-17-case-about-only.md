# Case and About Only Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce the portfolio homepage to only the approved success case and personal introduction.

**Architecture:** Keep the existing single-file HTML/CSS/JavaScript site and its Research Lab visual system. Update structural tests first, then remove unrelated sections and navigation references while preserving the case, about, accessibility, and responsive behavior.

**Tech Stack:** HTML5, CSS, vanilla JavaScript, PowerShell structural tests

## Global Constraints

- Main content contains only `section#case-study` and `section#about`.
- Preserve the current case video, approved evidence copy, portrait, biography, and eight skill tags.
- Keep responsive, menu, skip-link, focus, and reduced-motion behavior.
- Add no dependencies and no contact form or new CTA.

---

### Task 1: Replace structural expectations

**Files:**
- Modify: `tests/site-checks.ps1`
- Modify: `tests/expected-content.txt`

**Interfaces:**
- Consumes: `index.html` section IDs and approved copy.
- Produces: a test suite that accepts exactly the case-and-about page.

- [ ] **Step 1: Write the failing test**

Replace obsolete service, GEO, process, and FAQ assertions with checks that count exactly two sections, preserve `case-study` and `about`, reject removed section IDs and links, and preserve the video, portrait, biography, eight skills, accessibility hooks, and mobile rules.

- [ ] **Step 2: Run test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1`

Expected: FAIL because `home`, `geo`, `services`, `process`, and `faq` still exist.

- [ ] **Step 3: Commit the red test**

Run: `git add tests/site-checks.ps1 tests/expected-content.txt && git commit -m "test: define case and about only homepage"`

### Task 2: Reduce the homepage

**Files:**
- Modify: `index.html`
- Test: `tests/site-checks.ps1`

**Interfaces:**
- Consumes: the exact structural contract from Task 1.
- Produces: a two-section homepage with existing navigation behavior.

- [ ] **Step 1: Implement the minimal structure**

Remove `section#home`, `section#geo`, `section#services`, `section#process`, and `section#faq`. Reduce header and footer links to `#case-study` and `#about`; keep the existing case and about markup and required JavaScript targets.

- [ ] **Step 2: Run structural tests**

Run: `powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1`

Expected: `PASS: case-and-about-only structural checks`.

- [ ] **Step 3: Run static smoke checks**

Run: `node tests/static-server.cjs 4173` and inspect the rendered desktop and 375px page for horizontal overflow, visible video, visible portrait, and working mobile navigation.

- [ ] **Step 4: Commit the implementation**

Run: `git add index.html && git commit -m "refactor: focus homepage on case and introduction"`
