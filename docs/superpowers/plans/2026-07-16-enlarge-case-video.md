# Enlarge Case Video Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Increase the desktop first-screen video width by about 16% without changing copy, section order, or mobile behavior.

**Architecture:** Keep the current case-first markup. Add one case-specific container token and change only the desktop grid proportion; preserve the existing single-column breakpoint at 1024px and the 28px mobile gutter at 640px.

**Tech Stack:** CSS custom properties, CSS Grid, PowerShell regression checks.

## Global Constraints

- Keep all visible copy, assets, section order, menu behavior, and responsive content order unchanged.
- Set the desktop case container maximum to exactly `1260px`.
- Set the desktop case columns to exactly `0.72fr` text and `1.28fr` video.
- Keep the case layout single-column at widths of `1024px` and below.
- Keep the small-screen case gutter at `calc(100% - 28px)`.

---

### Task 1: Enlarge the desktop case-study video

**Files:**
- Modify: `tests/site-checks.ps1`
- Modify: `index.html`

**Interfaces:**
- Consumes: Existing `--container`, `.container`, `.case-first-grid`, and `@media (max-width: 640px)` rules.
- Produces: `--case-container: 1260px`, a `0.72fr / 1.28fr` desktop case grid, and unchanged mobile gutters.

- [ ] **Step 1: Add failing size-contract assertions**

Add these assertions before the failure-report block in `tests/site-checks.ps1`:

```powershell
Assert-Contains '--case-container: 1260px;' 'Expanded case container token is missing.'
Assert-Contains 'grid-template-columns: minmax(0, 0.72fr) minmax(0, 1.28fr);' 'Desktop case grid must allocate 64 percent to video.'
Assert-Contains 'width: min(calc(100% - 28px), var(--case-container));' 'Mobile case gutter must remain 14px per side.'
```

- [ ] **Step 2: Verify the new assertions fail**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1` with the three new size-contract failure messages.

- [ ] **Step 3: Implement the approved desktop sizing**

Add this token next to `--container` in `:root`:

```css
--case-container: 1260px;
```

Update `.case-first-grid` to include:

```css
.case-first-grid {
  width: min(calc(100% - 40px), var(--case-container));
  grid-template-columns: minmax(0, 0.72fr) minmax(0, 1.28fr);
}
```

Inside `@media (max-width: 640px)`, keep the existing single-column rule and add:

```css
.case-first-grid {
  width: min(calc(100% - 28px), var(--case-container));
}
```

- [ ] **Step 4: Verify all regression checks pass**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `PASS: structural and content checks`.

- [ ] **Step 5: Commit the approved revision**

```powershell
git add index.html tests/site-checks.ps1 docs/superpowers/specs/2026-07-16-research-lab-portfolio-redesign.md docs/superpowers/plans/2026-07-16-enlarge-case-video.md
git commit -m "style: enlarge case study video"
```
