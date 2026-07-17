# Additional 15% Case Video Enlargement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Increase the maximum desktop case-study video width from about 902px to about 1042px while preserving the current composition and responsive behavior.

**Architecture:** Keep the existing HTML and CSS Grid structure. Raise only the case-specific container token, update its regression assertion first, and retain the approved 30/70 grid and all responsive rules.

**Tech Stack:** HTML, CSS custom properties, CSS Grid, PowerShell regression checks.

## Global Constraints

- Set `--case-container` to exactly `1560px`.
- Keep desktop `.case-first-grid` columns at exactly `minmax(0, 0.6fr) minmax(0, 1.4fr)`.
- Keep the layout single-column at `1024px` and below.
- Keep the small-screen case width at `calc(100% - 28px)`.
- Keep markup, copy, video source, aspect ratio, section order, navigation, and unrelated styles unchanged.

---

### Task 1: Enlarge and protect the desktop case video

**Files:**
- Modify: `tests/site-checks.ps1:82`
- Modify: `index.html:67`

**Interfaces:**
- Consumes: Existing `Assert-Contains` helper and `--case-container` CSS custom property.
- Produces: A `1560px` maximum case container with a regression-protected sizing contract.

- [ ] **Step 1: Write the failing size-contract assertion**

Replace the assertion at `tests/site-checks.ps1:82` with:

```powershell
Assert-Contains '--case-container: 1560px;' 'Expanded case container token must remain at 1560px.'
```

- [ ] **Step 2: Run the regression suite and verify the new contract fails**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1` with `Expanded case container token must remain at 1560px.` Existing grid, breakpoint, and mobile-gutter assertions continue to pass.

- [ ] **Step 3: Implement the minimal CSS change**

Replace the token at `index.html:67` with:

```css
--case-container: 1560px;
```

Do not change `.case-first-grid`, the `1024px` breakpoint, or the `640px` mobile width rule.

- [ ] **Step 4: Run all static regression checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `0` with `PASS: case-and-about-only structural checks`.

- [ ] **Step 5: Inspect desktop and mobile renders**

Serve `index.html` using `node tests/static-server.cjs`, then render at `1600x1000` and `390x844`. Confirm the desktop video is about 1042px at the maximum container width, and neither viewport has overflow, clipping, overlap, or unintended responsive changes.

- [ ] **Step 6: Commit the implementation**

```powershell
git add -- index.html tests/site-checks.ps1 docs/superpowers/plans/2026-07-17-enlarge-case-video-additional-15-percent.md
git commit -m "style: enlarge case video another 15 percent"
```
