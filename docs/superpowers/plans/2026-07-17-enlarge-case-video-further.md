# Further Enlarge Case Video Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Increase the desktop case-study video width by about 18% while preserving all content and responsive behavior.

**Architecture:** Keep the existing case-first markup and CSS Grid structure. Update the case-specific container token and desktop column ratio only, then lock the approved desktop and mobile sizing into the existing static regression suite.

**Tech Stack:** HTML, CSS custom properties, CSS Grid, PowerShell regression checks.

## Global Constraints

- Set `--case-container` to exactly `1360px`.
- Set desktop `.case-first-grid` columns to exactly `minmax(0, 0.6fr) minmax(0, 1.4fr)`.
- Keep the layout single-column at `1024px` and below.
- Keep the small-screen case width at `calc(100% - 28px)`.
- Keep all markup, visible copy, video source, section order, visual styling, and navigation unchanged.

---

### Task 1: Enlarge and protect the case-study video layout

**Files:**
- Modify: `tests/site-checks.ps1:79-82`
- Modify: `index.html:67,1063-1069`

**Interfaces:**
- Consumes: Existing `Assert-Contains`, `--case-container`, `.case-first-grid`, and responsive media-query rules.
- Produces: A `1360px` desktop case container, 30/70 desktop column allocation, and regression protection for desktop and mobile sizing.

- [ ] **Step 1: Write failing size-contract assertions**

Add before the failure-report block in `tests/site-checks.ps1`:

```powershell
Assert-Contains '--case-container: 1360px;' 'Expanded case container token must remain at 1360px.'
Assert-Contains 'grid-template-columns: minmax(0, 0.6fr) minmax(0, 1.4fr);' 'Desktop case grid must allocate 70 percent to video.'
Assert-Contains '@media (max-width: 1024px)' 'Tablet breakpoint must remain.'
Assert-Contains 'width: min(calc(100% - 28px), var(--case-container));' 'Mobile case gutter must remain 14px per side.'
```

- [ ] **Step 2: Run the regression suite and confirm the new contract fails**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1`; failures report the missing `1360px` token and missing `0.6fr / 1.4fr` grid. Existing breakpoint and mobile-gutter assertions already pass.

- [ ] **Step 3: Implement the approved desktop sizing**

In `index.html`, update the root token and desktop grid to:

```css
--case-container: 1360px;
```

```css
.case-first-grid {
  display: grid;
  width: min(calc(100% - 40px), var(--case-container));
  grid-template-columns: minmax(0, 0.6fr) minmax(0, 1.4fr);
  align-items: center;
  gap: clamp(36px, 5vw, 72px);
}
```

Do not change the existing `@media (max-width: 1024px)` single-column rule or the `@media (max-width: 640px)` case width.

- [ ] **Step 4: Run all static regression checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `0` and `PASS: case-and-about-only structural checks`.

- [ ] **Step 5: Visually verify desktop and mobile layouts**

Run the local static server:

```powershell
node tests/static-server.cjs
```

Render the homepage at `1440x900` and `390x844`. Confirm the desktop video is visibly larger, the desktop text remains readable, and the mobile page has no overflow, clipping, overlap, or layout changes.

- [ ] **Step 6: Commit the implementation**

```powershell
git add -- index.html tests/site-checks.ps1 docs/superpowers/plans/2026-07-17-enlarge-case-video-further.md
git commit -m "style: enlarge case study video further"
```
