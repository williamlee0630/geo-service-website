# Center Research Thesis Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the AI-search illustration from the research thesis section and center the preserved copy in a balanced single-column layout.

**Architecture:** Keep `#home` as the existing research thesis section, but reduce its markup to the current `.hero-content` only. Replace the two-column grid rules with a centered content column, remove illustration-only CSS, and redirect the existing CTA to the current Services section.

**Tech Stack:** Static HTML, CSS, PowerShell structural tests

## Global Constraints

- Remove `.hero-visual` and all illustration-only content and CSS.
- Preserve every visible line of research thesis copy and the existing CTA label.
- Change only the CTA target from removed `#advantages` to existing `#services`.
- Keep the case-study video and all other page sections unchanged.
- Preserve the existing mobile full-width button and responsive title sizing.

---

### Task 1: Convert the research thesis to a centered single column

**Files:**
- Modify: `tests/expected-content.txt`
- Modify: `tests/site-checks.ps1`
- Modify: `index.html:402-531`
- Modify: `index.html:1321-1400`
- Modify: `index.html:1550-1577`
- Modify: `index.html:1645-1647`
- Modify: `index.html:1733-1743`
- Modify: `index.html:1911-1991`

**Interfaces:**
- Consumes: Existing `#home`, `.research-thesis-grid`, `.hero-content`, `.hero-actions`, and `#services` anchors.
- Produces: A centered text-only `#home` section whose CTA links to `#services`.

- [ ] **Step 1: Add preserved and removed copy fixtures**

Append these lines to `tests/expected-content.txt`:

```text
hero_badge	小型網站 GEO 優化
hero_heading	讓生成式搜尋更容易
hero_heading_emphasis	理解你的網站
hero_description	我們從網站主題、內容架構、FAQ、內部連結與結構化資料著手，
hero_cta	了解優化內容
hero_note	這項服務不承諾結果
hero_removed_query	這家公司提供哪些服務？
hero_removed_summary	AI 搜尋摘要
hero_removed_topic	每一頁都要有明確主題
```

- [ ] **Step 2: Write the failing structural checks**

Add these assertions after the existing research thesis order assertions in `tests/site-checks.ps1`:

```powershell
Assert-ContainsInSection 'home' $expected['hero_badge'] 'Research thesis badge copy must remain.'
Assert-ContainsInSection 'home' $expected['hero_heading'] 'Research thesis heading must remain.'
Assert-ContainsInSection 'home' $expected['hero_heading_emphasis'] 'Research thesis emphasized heading must remain.'
Assert-ContainsInSection 'home' $expected['hero_description'] 'Research thesis description must remain.'
Assert-ContainsInSection 'home' $expected['hero_cta'] 'Research thesis CTA label must remain.'
Assert-ContainsInSection 'home' $expected['hero_note'] 'Research thesis limitation note must remain.'
Assert-NotContainsInSection 'home' 'class="hero-visual"' 'Research thesis illustration markup must be removed.'
Assert-NotContainsInSection 'home' $expected['hero_removed_query'] 'AI-search query illustration copy must be removed.'
Assert-NotContainsInSection 'home' $expected['hero_removed_summary'] 'AI-search summary illustration copy must be removed.'
Assert-NotContainsInSection 'home' $expected['hero_removed_topic'] 'Floating technical illustration copy must be removed.'
Assert-Count ([regex]::Escape('.hero-visual')) 0 'Hero visual CSS and markup must be removed.'
Assert-Count ([regex]::Escape('.search-card')) 0 'Search-card CSS and markup must be removed.'
Assert-Count ([regex]::Escape('.floating-card')) 0 'Floating-card CSS and markup must be removed.'
Assert-Contains '<a class="button button-primary" href="#services">' 'Research thesis CTA must target Services.'
Assert-Count 'href="#advantages"' 0 'No CTA may target the removed Advantages section.'
Assert-Count '(?s)\.research-thesis \.hero-content\s*\{[^}]*max-width:\s*860px;[^}]*text-align:\s*center;' 1 'Centered research thesis content rules are missing.'
Assert-Count '(?s)\.research-thesis \.hero-actions\s*\{[^}]*justify-content:\s*center;' 1 'Research thesis actions must be centered.'
```

Define this helper immediately after `Assert-Contains` so preserved copy checks are scoped to `#home`:

```powershell
function Assert-ContainsInSection([string]$sectionId, [string]$needle, [string]$message) {
  $pattern = '(?s)<section[^>]+id="' + [regex]::Escape($sectionId) + '".*?</section>'
  $match = [regex]::Match($script:html, $pattern)
  if (-not $match.Success -or -not $match.Value.Contains($needle)) {
    $script:failures.Add($message)
  }
}
```

- [ ] **Step 3: Run checks and verify the new expectations fail**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\site-checks.ps1
```

Expected: FAIL because illustration markup and CSS remain, the CTA still targets `#advantages`, and centered content rules are absent.

- [ ] **Step 4: Remove illustration-only base CSS**

Delete the complete CSS rule groups for:

```css
.hero-visual
.search-card
.window-bar
.window-dot
.search-box
.ai-answer
.ai-label
.answer-line
.source-list
.source-item
.source-number
.floating-card
.floating-card strong
.floating-card span
```

Also delete the research-thesis-specific `.search-card` and `.floating-card` overrides and all responsive `.hero-visual`, `.search-card`, and `.floating-card` rules. Do not change unrelated hero, case-study, or card CSS.

- [ ] **Step 5: Replace the two-column research thesis layout rules**

Set the desktop rules to:

```css
.research-thesis-grid {
  display: block;
}

.research-thesis .hero-content {
  max-width: 860px;
  margin: 0 auto;
  text-align: center;
}

.research-thesis .hero-description,
.research-thesis .hero-note {
  margin-right: auto;
  margin-left: auto;
  color: #aebbd2;
}

.research-thesis .hero-note {
  max-width: 760px;
}

.research-thesis .hero-actions {
  justify-content: center;
}
```

Remove `.research-thesis-grid` from the `max-width: 1024px` multi-selector and remove the now-redundant responsive `.research-thesis .hero-content` and `.research-thesis .hero-visual` rules.

- [ ] **Step 6: Remove the illustration markup and repair the CTA target**

Change the CTA opening tag to:

```html
<a class="button button-primary" href="#services">
```

Delete the complete `<div class="hero-visual" aria-hidden="true">...</div>` block. Preserve the `.hero-content` markup and every visible line inside it exactly.

- [ ] **Step 7: Run the complete structural checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\site-checks.ps1
```

Expected: `PASS: structural and content checks`

- [ ] **Step 8: Review the focused diff**

Run:

```powershell
git diff -- index.html tests/site-checks.ps1 tests/expected-content.txt
```

Expected: Only illustration markup/CSS is deleted, research thesis alignment rules are changed, the CTA target is repaired, and regression fixtures/checks are added.

- [ ] **Step 9: Commit the implementation**

```powershell
git add -- index.html tests/site-checks.ps1 tests/expected-content.txt docs/superpowers/plans/2026-07-16-center-research-thesis.md
git commit -m "refactor: center research thesis content"
```
