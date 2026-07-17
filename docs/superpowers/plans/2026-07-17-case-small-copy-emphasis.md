# Case Small Copy Emphasis Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the case-study supporting copy noticeably clearer using the approved Option A typography without changing content or layout.

**Architecture:** Keep the existing markup and selector structure. Add exact static contracts for the approved typography first, then change only `.case-lead` and `.case-evidence-copy p` declarations.

**Tech Stack:** HTML, CSS, PowerShell regression checks.

## Global Constraints

- Set `.case-lead` to `color: #d7e0ee`, `font-size: clamp(1.06rem, 1.5vw, 1.18rem)`, and `font-weight: 600`.
- Set `.case-evidence-copy p` to `color: #cbd6e8`, `font-size: 0.96rem`, and `font-weight: 550`.
- Keep both existing line heights unchanged.
- Keep all text, markup, spacing, labels, headings, video sizing, and responsive layout unchanged.

---

### Task 1: Strengthen and protect case supporting copy

**Files:**
- Modify: `tests/site-checks.ps1:86`
- Modify: `index.html:1126-1159`

**Interfaces:**
- Consumes: Existing `Assert-Contains` helper and the `.case-lead` and `.case-evidence-copy p` selectors.
- Produces: Regression-protected supporting text with the approved Option A contrast, size, and weight.

- [ ] **Step 1: Write failing typography-contract assertions**

Add before the failure-report block in `tests/site-checks.ps1`:

```powershell
Assert-Contains 'color: #d7e0ee;' 'Case lead must use the approved brighter color.'
Assert-Contains 'font-size: clamp(1.06rem, 1.5vw, 1.18rem);' 'Case lead must use the approved larger size.'
Assert-Contains 'font-weight: 600;' 'Case lead must use the approved semibold weight.'
Assert-Contains 'color: #cbd6e8;' 'Case evidence copy must use the approved brighter color.'
Assert-Contains 'font-size: 0.96rem;' 'Case evidence copy must use the approved larger size.'
Assert-Contains 'font-weight: 550;' 'Case evidence copy must use the approved medium weight.'
```

- [ ] **Step 2: Run the regression suite and verify the contracts fail**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1`; failures name the missing brighter colors, larger sizes, and `550` evidence-copy weight. The generic `font-weight: 600` assertion may already pass because another selector uses that weight.

- [ ] **Step 3: Implement the approved Option A typography**

Update the two selectors in `index.html` to:

```css
.case-lead {
  color: #d7e0ee;
  font-size: clamp(1.06rem, 1.5vw, 1.18rem);
  font-weight: 600;
  line-height: 1.85;
}
```

```css
.case-evidence-copy p {
  color: #cbd6e8;
  font-size: 0.96rem;
  font-weight: 550;
  line-height: 1.75;
}
```

- [ ] **Step 4: Run all static regression checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `0` with `PASS: case-and-about-only structural checks`.

- [ ] **Step 5: Review the final diff and commit**

Run `git diff --check` and confirm that only the six approved declarations and their regression assertions changed. Then commit:

```powershell
git add -- index.html tests/site-checks.ps1 docs/superpowers/plans/2026-07-17-case-small-copy-emphasis.md
git commit -m "style: emphasize case supporting copy"
```
