# Research Lab Portfolio Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the existing one-page GEO portfolio as a Research Lab site that presents the current case-study video in the first viewport, preserves all approved content, and replaces the implementation-heavy service section with approved outcome-oriented copy.

**Architecture:** Keep the project dependency-free and retain `index.html` as the single production artifact. Add one PowerShell regression script that treats important copy, section order, semantic attributes, responsive safeguards, and privacy-sensitive service wording as a content contract.

**Tech Stack:** Semantic HTML5, CSS custom properties and media queries, vanilla JavaScript, PowerShell 5-compatible regression checks.

## Global Constraints

- Keep the existing YouTube video, portrait, FAQ, SEO meta, Open Graph data, JSON-LD, and every other visible copy block unchanged unless this plan supplies replacement copy.
- Keep the case-study video visible in the first viewport on desktop and in the first content block on mobile.
- Replace only the current `網站會怎麼調整` section copy with the approved `合作會處理哪些問題` outcome-oriented copy.
- Do not display the removed implementation checklist terms in the service section: `Meta title 與 description`, `Canonical 與內部連結`, `Sitemap、robots.txt 與爬取檢查`, `Schema 結構化資料`, or `固定問題的 AI 搜尋測試`.
- Keep the project as a single production `index.html`; do not add a framework, package manager, remote font, or runtime dependency.
- Preserve the current asset paths `assets/site-icon.png` and `assets/about-photo.jpg` and the privacy-enhanced YouTube URL.
- Support a 375px viewport without horizontal scrolling and honor `prefers-reduced-motion`.

---

## File Map

- Modify: `index.html` — production markup, Research Lab visual system, responsive rules, and menu behavior.
- Create: `tests/site-checks.ps1` — dependency-free content, structure, privacy, accessibility, and responsive regression contract.
- Reference: `docs/superpowers/specs/2026-07-16-research-lab-portfolio-redesign.md` — approved design source of truth.

### Task 1: Lock the content contract and implement the case-first structure

**Files:**
- Create: `tests/site-checks.ps1`
- Modify: `index.html:1207-1380`
- Modify: `index.html:1462-1550`

**Interfaces:**
- Consumes: Existing section IDs `case-study`, `home`, `geo`, `services`, `advantages`, `process`, `about`, and `faq`.
- Produces: A first-screen `.case-first` section, a following `.research-thesis` section, and a four-card `#services` section with approved outcome-oriented copy.

- [ ] **Step 1: Write the failing structural and content regression script**

Create `tests/site-checks.ps1` with this complete content:

```powershell
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $projectRoot 'index.html'
$html = Get-Content -Raw -Encoding utf8 $indexPath
$failures = New-Object System.Collections.Generic.List[string]

function Assert-Contains([string]$needle, [string]$message) {
  if (-not $script:html.Contains($needle)) {
    $script:failures.Add($message)
  }
}

function Assert-NotContainsInSection([string]$sectionId, [string]$needle, [string]$message) {
  $pattern = '(?s)<section[^>]+id="' + [regex]::Escape($sectionId) + '".*?</section>'
  $match = [regex]::Match($script:html, $pattern)
  if (-not $match.Success -or $match.Value.Contains($needle)) {
    $script:failures.Add($message)
  }
}

function Assert-Before([string]$first, [string]$second, [string]$message) {
  $firstIndex = $script:html.IndexOf($first)
  $secondIndex = $script:html.IndexOf($second)
  if ($firstIndex -lt 0 -or $secondIndex -lt 0 -or $firstIndex -ge $secondIndex) {
    $script:failures.Add($message)
  }
}

function Assert-Count([string]$pattern, [int]$expected, [string]$message) {
  $actual = [regex]::Matches($script:html, $pattern).Count
  if ($actual -ne $expected) {
    $script:failures.Add("$message Expected $expected, found $actual.")
  }
}

Assert-Contains 'class="case-first" id="case-study"' 'Case study must use the first-screen case-first layout.'
Assert-Contains 'class="research-thesis" id="home"' 'Original hero copy must follow as the research thesis.'
Assert-Before 'id="case-study"' 'id="home"' 'Case study must appear before the research thesis.'
Assert-Before 'id="home"' 'id="geo"' 'Research thesis must appear before the GEO explanation.'
Assert-Contains 'https://www.youtube-nocookie.com/embed/6hwyCr4K378?rel=0' 'Privacy-enhanced case-study video URL must be preserved.'
Assert-Contains '畫面展示查詢關鍵字後，生成式搜尋整理出的 AI 摘要。' 'Approved case-study evidence copy must be preserved.'
Assert-Contains '這項服務不承諾結果' 'Result limitation statement must be preserved.'
Assert-Contains '<h2>合作會處理哪些問題</h2>' 'Service section must use the approved outcome-oriented heading.'
Assert-Contains '釐清網站現況' 'Service card 1 heading is missing.'
Assert-Contains '整理重要資訊' 'Service card 2 heading is missing.'
Assert-Contains '改善網站基礎' 'Service card 3 heading is missing.'
Assert-Contains '觀察調整結果' 'Service card 4 heading is missing.'
Assert-NotContainsInSection 'services' 'Meta title 與 description' 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' 'Canonical 與內部連結' 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' 'Sitemap、robots.txt 與爬取檢查' 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' 'Schema 結構化資料' 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' '固定問題的 AI 搜尋測試' 'Service section reveals implementation checklist details.'
Assert-Count '<details class="faq-item"' 8 'All eight FAQ items must remain.'
Assert-Count '<span class="skill">' 8 'All eight skill tags must remain.'
Assert-Contains 'assets/about-photo.jpg' 'Portrait asset must remain.'
Assert-Contains 'application/ld+json' 'JSON-LD must remain.'
Assert-Contains 'property="og:title"' 'Open Graph title must remain.'

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  exit 1
}

Write-Output 'PASS: structural and content checks'
```

- [ ] **Step 2: Run the script and verify it fails for the unimplemented design**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1`, including failures for `.case-first`, `.research-thesis`, and `合作會處理哪些問題`.

- [ ] **Step 3: Replace the case-study and Hero wrappers without changing their approved copy**

In `index.html`, keep `#case-study` first inside `<main>`, change its opening tag to:

```html
<section class="case-first" id="case-study">
  <div class="container case-first-grid">
    <div class="case-first-copy">
      <span class="lab-index">Case Study / 01</span>
      <span class="evidence-badge">AI 摘要引用實證</span>
      <h1>GEO／SEO<br>實例呈現</h1>
      <p class="case-lead">
        以下展示我們團隊對特定網站進行GEO優化後，成功讓施作網站超越大型網站被AI摘要收錄並引用。
      </p>
      <div class="case-evidence-copy">
        <strong>網站出現在該次 AI 摘要中</strong>
        <p>
          畫面展示查詢關鍵字後，生成式搜尋整理出的 AI 摘要。
          摘要內容引用了團隊施作的網站。
        </p>
        <p>
          由於生成式語言模型的回應具有機率性，
          GEO 優化的目的就是提升內容被辨識、收錄與引用的機會。
        </p>
      </div>
    </div>
    <div class="case-first-media">
      <div class="case-video-frame">
        <div class="case-video-meta">
          <span>Evidence recording</span>
          <span>16:9 / YouTube</span>
        </div>
        <div class="case-video">
          <iframe
            src="https://www.youtube-nocookie.com/embed/6hwyCr4K378?rel=0"
            title="飯店推薦網站出現在 AI 摘要的查詢紀錄"
            loading="lazy"
            referrerpolicy="strict-origin-when-cross-origin"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            allowfullscreen
          ></iframe>
        </div>
      </div>
    </div>
  </div>
</section>
```

Change the existing Hero opening tag from `<section class="hero" id="home">` to `<section class="research-thesis" id="home">`. Keep its badge, title, description, action, note, and AI-search visual text unchanged, but rename its outer layout class from `hero-grid` to `research-thesis-grid`.

- [ ] **Step 4: Replace only the service section copy with the approved outcome-oriented version**

Keep `<section ... id="services">` and its four-card structure, but replace the section header and card contents with:

```html
<div class="section-header center">
  <span class="eyebrow">Services</span>
  <h2>合作會處理哪些問題</h2>
  <p class="section-description">
    會依網站現況、內容規模與主要目標安排調整方向。合作重點是讓網站定位更清楚、
    內容更容易理解，並建立可持續觀察的基礎。
  </p>
</div>

<div class="service-grid">
  <article class="card service-card">
    <div class="service-icon">01</div>
    <h3>釐清網站現況</h3>
    <p>先確認網站目前的定位、內容狀態與主要問題，找出值得優先處理的方向。</p>
  </article>
  <article class="card service-card">
    <div class="service-icon">02</div>
    <h3>整理重要資訊</h3>
    <p>讓服務、案例與重要內容有更清楚的呈現方式，降低訪客與搜尋系統理解網站的難度。</p>
  </article>
  <article class="card service-card">
    <div class="service-icon">03</div>
    <h3>改善網站基礎</h3>
    <p>處理影響網站被發現、閱讀與長期維護的基礎問題，讓後續內容能穩定累積。</p>
  </article>
  <article class="card service-card">
    <div class="service-icon">04</div>
    <h3>觀察調整結果</h3>
    <p>保留調整前後的資料與呈現紀錄，作為後續優化與內容更新的判斷依據。</p>
  </article>
</div>
```

- [ ] **Step 5: Run the regression script and verify the structure and content pass**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `PASS: structural and content checks`.

- [ ] **Step 6: Commit the case-first structure and approved copy change**

```powershell
git add index.html tests/site-checks.ps1
git commit -m "feat: make portfolio case-first"
```

### Task 2: Apply the Research Lab visual system and responsive layout

**Files:**
- Modify: `tests/site-checks.ps1`
- Modify: `index.html:44-1204`

**Interfaces:**
- Consumes: `.case-first`, `.case-first-grid`, `.research-thesis`, `.research-thesis-grid`, `.service-grid`, and the existing section IDs from Task 1.
- Produces: CSS tokens and responsive layouts that expose the video immediately, maintain readable long-form sections, and prevent horizontal overflow at 375px.

- [ ] **Step 1: Add failing visual-system checks before changing CSS**

Insert these assertions before the failure-report block in `tests/site-checks.ps1`:

```powershell
Assert-Contains '--lab-ink: #07111f;' 'Research Lab ink token is missing.'
Assert-Contains '--lab-accent: #86a7ff;' 'Research Lab accent token is missing.'
Assert-Contains '.case-first-grid {' 'Case-first desktop grid styles are missing.'
Assert-Contains '.research-thesis-grid {' 'Research thesis layout styles are missing.'
Assert-Contains '@media (prefers-reduced-motion: reduce)' 'Reduced-motion support is missing.'
Assert-Contains '@media (max-width: 640px)' 'Small-screen breakpoint is missing.'
Assert-Contains 'overflow-x: clip;' 'Horizontal overflow safeguard is missing.'
```

- [ ] **Step 2: Run the script and verify the visual-system checks fail**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1` with missing token, grid, reduced-motion, and overflow safeguard messages.

- [ ] **Step 3: Replace the existing CSS system with the Research Lab tokens and base rules**

At the top of the existing `<style>` block, replace the current root tokens and body base rules with:

```css
:root {
  --lab-ink: #07111f;
  --lab-ink-soft: #0d1a30;
  --lab-panel: #12213b;
  --lab-accent: #86a7ff;
  --lab-accent-strong: #5f82ef;
  --lab-success: #52d69a;
  --paper: #f4f6fb;
  --surface: #ffffff;
  --surface-soft: #edf1f8;
  --text: #17233c;
  --muted: #62708a;
  --border: #d9e1ef;
  --border-dark: #263a5f;
  --shadow: 0 24px 70px rgba(8, 20, 43, 0.13);
  --radius-large: 26px;
  --radius-medium: 16px;
  --radius-small: 10px;
  --container: 1180px;
  --primary: var(--lab-accent-strong);
  --primary-dark: #4267d2;
  --primary-light: #e5ebff;
  --secondary: var(--lab-ink);
  --background: var(--paper);
  --success: var(--lab-success);
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  overflow-x: clip;
  scroll-behavior: smooth;
  scroll-padding-top: 88px;
}

body {
  overflow-x: clip;
  color: var(--text);
  background: var(--paper);
  font-family: Inter, "Noto Sans TC", "PingFang TC", "Microsoft JhengHei", sans-serif;
  line-height: 1.75;
}
```

Use the following structural CSS for the approved first-screen and thesis layouts. Keep the existing card, FAQ, about, and footer selectors intact; the compatibility aliases in `:root` reskin their current declarations without requiring selector changes:

```css
.case-first {
  position: relative;
  min-height: 100svh;
  padding: 132px 0 72px;
  color: #edf3ff;
  background-color: var(--lab-ink);
  background-image:
    linear-gradient(rgba(134, 167, 255, 0.07) 1px, transparent 1px),
    linear-gradient(90deg, rgba(134, 167, 255, 0.07) 1px, transparent 1px);
  background-size: 32px 32px;
}

.case-first-grid {
  display: grid;
  grid-template-columns: minmax(0, 0.82fr) minmax(0, 1.18fr);
  align-items: center;
  gap: clamp(36px, 5vw, 72px);
}

.case-first h1 {
  max-width: 620px;
  margin: 18px 0 22px;
  color: #ffffff;
  font-size: clamp(2.6rem, 5.5vw, 5.4rem);
  line-height: 0.98;
  letter-spacing: -0.055em;
}

.lab-index {
  color: var(--lab-accent);
  font-size: 0.76rem;
  font-weight: 900;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.evidence-badge {
  display: inline-flex;
  align-items: center;
  margin-left: 12px;
  padding: 7px 11px;
  color: #c8f8df;
  border: 1px solid rgba(82, 214, 154, 0.4);
  border-radius: 999px;
  background: rgba(82, 214, 154, 0.09);
  font-size: 0.76rem;
  font-weight: 850;
}

.case-lead,
.case-evidence-copy p {
  color: #b7c3d9;
}

.case-evidence-copy {
  margin-top: 28px;
  padding-top: 24px;
  border-top: 1px solid var(--border-dark);
}

.case-evidence-copy strong {
  display: block;
  margin-bottom: 8px;
  color: #ffffff;
}

.case-evidence-copy p + p {
  margin-top: 10px;
}

.case-video-frame {
  overflow: hidden;
  padding: 14px;
  border: 1px solid var(--border-dark);
  border-radius: var(--radius-large);
  background: rgba(16, 31, 56, 0.88);
  box-shadow: 0 30px 90px rgba(0, 0, 0, 0.34);
}

.case-video-meta {
  display: flex;
  justify-content: space-between;
  padding: 2px 4px 12px;
  color: #8da0c2;
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.research-thesis {
  position: relative;
  overflow: hidden;
  padding: 112px 0;
  color: #dfe8fa;
  background: var(--lab-ink-soft);
}

.research-thesis-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.05fr) minmax(360px, 0.95fr);
  align-items: center;
  gap: clamp(42px, 6vw, 80px);
}

.research-thesis h2,
.research-thesis h1,
.research-thesis h3 {
  color: #ffffff;
}

.research-thesis .hero-description,
.research-thesis .hero-note {
  color: #aebbd2;
}
```

- [ ] **Step 4: Add responsive and reduced-motion rules**

Merge these rules into the existing media-query area, removing obsolete `.hero` and `.case-shell` layout overrides that conflict with them:

```css
@media (max-width: 1024px) {
  .case-first-grid,
  .research-thesis-grid,
  .geo-grid,
  .about-grid {
    grid-template-columns: 1fr;
  }

  .case-first {
    min-height: auto;
  }

  .case-first-copy {
    max-width: 760px;
  }

  .case-first-media {
    width: 100%;
  }
}

@media (max-width: 640px) {
  .case-first {
    padding: 108px 0 58px;
  }

  .case-first-grid {
    gap: 24px;
  }

  .case-first h1 {
    font-size: clamp(2.35rem, 13vw, 3.4rem);
  }

  .case-first-copy {
    display: contents;
  }

  .case-first-copy > .lab-index,
  .case-first-copy > .evidence-badge,
  .case-first-copy > h1,
  .case-first-copy > .case-lead {
    grid-column: 1;
  }

  .case-first-media {
    grid-row: 5;
  }

  .case-evidence-copy {
    grid-row: 6;
  }

  .case-video-frame {
    padding: 8px;
    border-radius: 18px;
  }

  .case-video-meta {
    font-size: 0.6rem;
  }

  .research-thesis {
    padding: 76px 0;
  }

  .service-grid,
  .advantage-grid,
  .process-grid,
  .case-process,
  .case-two-column {
    grid-template-columns: 1fr;
  }
}

@media (prefers-reduced-motion: reduce) {
  html {
    scroll-behavior: auto;
  }

  *,
  *::before,
  *::after {
    scroll-behavior: auto !important;
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
  }
}
```

- [ ] **Step 5: Run the regression script and verify it passes**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `PASS: structural and content checks`.

- [ ] **Step 6: Commit the Research Lab styling**

```powershell
git add index.html tests/site-checks.ps1
git commit -m "feat: apply research lab visual system"
```

### Task 3: Replace the Emoji menu icon and verify responsive accessibility

**Files:**
- Modify: `tests/site-checks.ps1`
- Modify: `index.html:1214-1241`
- Modify: `index.html:1809-1828`

**Interfaces:**
- Consumes: Existing `#menuButton`, `#navLinks`, `.active`, and `body.menu-open` behavior.
- Produces: A stable CSS hamburger icon driven by `aria-expanded`, with unchanged anchor navigation behavior.

- [ ] **Step 1: Add failing accessibility and menu checks**

Insert these assertions before the failure-report block in `tests/site-checks.ps1`:

```powershell
Assert-Contains 'aria-controls="navLinks"' 'Menu button must identify the controlled navigation.'
Assert-Contains '<span class="menu-line"></span>' 'Menu button must use stable CSS icon lines.'
Assert-Contains 'menuButton.setAttribute("aria-label", isOpen ? "關閉選單" : "開啟選單");' 'Menu state must update its accessible label.'
if ($html.Contains('☰') -or $html.Contains('✕')) {
  $failures.Add('Structural UI must not use Emoji menu icons.')
}
```

- [ ] **Step 2: Run the script and verify the menu checks fail**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1` with missing `aria-controls`, missing `.menu-line`, and Emoji menu icon failures.

- [ ] **Step 3: Replace the menu button contents and update its JavaScript state**

Use this exact button markup:

```html
<button
  class="menu-button"
  id="menuButton"
  type="button"
  aria-label="開啟選單"
  aria-controls="navLinks"
  aria-expanded="false"
>
  <span class="menu-line"></span>
  <span class="menu-line"></span>
  <span class="menu-line"></span>
</button>
```

Replace the menu-button click handler with:

```javascript
menuButton.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("active");

  menuButton.setAttribute("aria-expanded", String(isOpen));
  menuButton.setAttribute("aria-label", isOpen ? "關閉選單" : "開啟選單");
  document.body.classList.toggle("menu-open", isOpen);
});
```

Replace the navigation-item reset body with:

```javascript
navLinks.classList.remove("active");
menuButton.setAttribute("aria-expanded", "false");
menuButton.setAttribute("aria-label", "開啟選單");
document.body.classList.remove("menu-open");
```

Add these icon rules next to `.menu-button`:

```css
.menu-button {
  align-content: center;
  justify-items: center;
  gap: 5px;
}

.menu-line {
  display: block;
  width: 20px;
  height: 2px;
  border-radius: 999px;
  background: currentColor;
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.menu-button[aria-expanded="true"] .menu-line:nth-child(1) {
  transform: translateY(7px) rotate(45deg);
}

.menu-button[aria-expanded="true"] .menu-line:nth-child(2) {
  opacity: 0;
}

.menu-button[aria-expanded="true"] .menu-line:nth-child(3) {
  transform: translateY(-7px) rotate(-45deg);
}
```

- [ ] **Step 4: Run automated checks**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `PASS: structural and content checks`.

- [ ] **Step 5: Perform browser verification at four viewport states**

Serve the workspace with a local static server, then inspect the page at these exact states:

```powershell
python -m http.server 4173
```

Verify:

- `1440 × 900`: case copy and video share the first viewport; no player controls are obscured.
- `768 × 1024`: layout is single-column with the video still near the top and cards reduced to two columns where appropriate.
- `375 × 812`: no horizontal scrolling; case title is followed by the video before long evidence copy; menu opens, closes, and restores body scrolling.
- `375 × 812` with reduced motion: transitions are effectively disabled and all content remains visible.
- Keyboard-only: skip through navigation, CTA, video iframe, and FAQ summaries; focus indicators remain visible.

Expected: all five checks pass with no browser console errors.

- [ ] **Step 6: Commit accessibility and responsive verification changes**

```powershell
git add index.html tests/site-checks.ps1
git commit -m "fix: polish responsive navigation accessibility"
```

### Task 4: Final regression and scope audit

**Files:**
- Verify: `index.html`
- Verify: `tests/site-checks.ps1`
- Verify: `docs/superpowers/specs/2026-07-16-research-lab-portfolio-redesign.md`

**Interfaces:**
- Consumes: All selectors, copy contracts, and behaviors produced by Tasks 1–3.
- Produces: Verified production-ready static site with no uncommitted implementation changes.

- [ ] **Step 1: Run the complete automated regression script from a fresh PowerShell process**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `PASS: structural and content checks` and exit code `0`.

- [ ] **Step 2: Check whitespace, tracked files, and commit history**

```powershell
git diff --check
git status --short
git log -4 --oneline
```

Expected:

- `git diff --check` prints nothing.
- `git status --short` prints nothing.
- The latest commits include the design spec and the implementation commits from Tasks 1–3.

- [ ] **Step 3: Compare production HTML against the approved spec**

Confirm all of the following directly in `index.html`:

- The case-study video is the first main content block.
- Original Hero copy follows as the research thesis.
- The service section contains exactly four outcome-oriented cards and no removed implementation checklist.
- The portrait, eight skill tags, eight FAQ items, SEO meta, Open Graph, and JSON-LD remain.
- No new form, tracker, remote font, framework, or dependency was added.

Expected: no scope gaps or unapproved content changes.
