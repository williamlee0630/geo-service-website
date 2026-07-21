# GEO Researcher Positioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reframe the existing two-section site around an ongoing GEO experimenter and researcher, while retaining the current layout and presenting website-building and data-analysis skills as research methods.

**Architecture:** Keep the single-file site and its current case/about section structure. Update the static-content contract first, then revise metadata, structured data, navigation, case copy, biography, accessibility text, and footer in `index.html`; CSS changes are allowed only if visual verification finds a regression caused by the new copy.

**Tech Stack:** Static HTML, embedded CSS and JavaScript, PowerShell content assertions, local Node.js static server.

## Global Constraints

- Keep exactly two main sections: `#case-study` and `#about`.
- Preserve the desktop left-copy/right-video case layout and lower left-image/right-copy about layout.
- Preserve the existing Research Lab visual system, assets, video, responsive behavior, menu interaction, and anchor links.
- Do not add dependencies, sections, contact forms, service pricing, case indexes, blogs, or a CMS.
- Use first-person singular copy; do not present a single observed AI-summary result as guaranteed or repeatable performance.
- Retain exactly eight skill tags and explain practical skills as methods that support the research.
- Leave placeholder canonical and site URLs unchanged; do not invent a domain or contact details.

---

### Task 1: Define the Researcher Copy Contract

**Files:**
- Modify: `tests/expected-content.txt`
- Modify: `tests/site-checks.ps1`
- Test: `tests/site-checks.ps1`

**Interfaces:**
- Consumes: Existing tab-delimited expected-content loader and `Assert-Contains`, `Assert-NotContains`, `Assert-ContainsInSection`, and `Assert-Count` helpers.
- Produces: A failing static-content contract for the researcher positioning that Task 2 must satisfy.

- [ ] **Step 1: Replace the expected copy fixture**

Set `tests/expected-content.txt` to the following exact tab-delimited content:

```text
case_copy	這是我針對一個小型、低權重網站進行的 GEO 實作觀察，想理解內容結構與技術設定，是否能提高網站被搜尋引擎與生成式 AI 辨識的機會。
case_heading	一次 GEO 實驗的<br>觀察紀錄
case_evidence_heading	這次查詢觀察到什麼
case_evidence_copy	這個結果提供了一次可觀察的紀錄，但不代表每次查詢都會出現相同答案。
case_probability	生成式搜尋的回應具有機率性，結果也可能隨時間、查詢方式與系統更新而改變。
case_probability_action	因此我把這次結果視為研究過程中的一筆證據，並持續觀察內容被理解、收錄與引用的條件。
about_heading	我如何研究 GEO
about_copy	我目前就讀資料科學系，持續研究 GEO、AEO 與生成式搜尋。
nav_case	研究紀錄
nav_about	關於我
menu_label_expression	menuButton.setAttribute("aria-label", isOpen ? "關閉選單" : "開啟選單");
```

- [ ] **Step 2: Add researcher-positioning assertions**

After the existing expected case-copy assertions in `tests/site-checks.ps1`, add:

```powershell
Assert-ContainsInSection 'case-study' 'Research Note / 01' 'Case-study index must identify a research note.'
Assert-ContainsInSection 'case-study' '生成式搜尋觀察' 'Case-study badge must frame the result as an observation.'
Assert-ContainsInSection 'case-study' '這次查詢中，這個網站出現於 AI 摘要中。' 'Case-study evidence must state the observed result precisely.'
Assert-ContainsInSection 'about' '為了驗證這些問題，我不只閱讀資料，也會實際建置網站、整理內容架構' 'Biography must connect practical work to research.'
Assert-Contains '<title>GEO 實驗與生成式搜尋研究｜個人研究紀錄</title>' 'Document title must use the researcher positioning.'
Assert-Contains '"jobTitle": "資料科學學生與 GEO 研究實作者"' 'Person structured data must use the researcher positioning.'

foreach ($salesPhrase in @('成功案例', '我們團隊', '施作', '中小企業 GEO 網站優化', '網站優化服務者')) {
  Assert-NotContains $salesPhrase "Sales-oriented phrase remains: $salesPhrase"
}
```

- [ ] **Step 3: Run the contract and verify that it fails against the old page**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `1`, with failures for the new research heading, biography, metadata, and old sales-oriented phrases.

- [ ] **Step 4: Commit the failing contract**

```powershell
git add -- tests/expected-content.txt tests/site-checks.ps1
git commit -m "test: define GEO researcher positioning copy"
```

---

### Task 2: Reframe the Existing Two-Section Page

**Files:**
- Modify: `index.html`
- Test: `tests/site-checks.ps1`

**Interfaces:**
- Consumes: The expected-content keys and researcher-positioning assertions defined in Task 1.
- Produces: A two-section static portfolio whose visible copy, metadata, structured data, accessibility text, and footer consistently present an ongoing GEO researcher with practical implementation skills.

- [ ] **Step 1: Update document metadata and structured data**

Use these exact values in `index.html`:

```html
<title>GEO 實驗與生成式搜尋研究｜個人研究紀錄</title>

<meta
  name="description"
  content="記錄我如何透過小型網站實驗，研究 GEO、AEO、內容結構與生成式搜尋可見性，並以網站建置與數據觀察驗證想法。"
>

<meta
  name="keywords"
  content="GEO, Generative Engine Optimization, AEO, 生成式搜尋, GEO 實驗, 網站內容架構, AI 可見性"
>

<meta name="author" content="李唯礽">
```

Set the Open Graph title to `GEO 實驗與生成式搜尋研究` and reuse the new description text above. In the Person JSON-LD, set `jobTitle` to `資料科學學生與 GEO 研究實作者`, remove `中小企業網站優化`, and add `生成式搜尋觀測` to `knowsAbout`.

- [ ] **Step 2: Update shared identity and navigation copy**

Use these exact visible strings while keeping the current elements and anchors:

```html
<span>GEO 實驗與研究紀錄</span>
...
<li><a href="#case-study">研究紀錄</a></li>
<li><a href="#about">關於我</a></li>
```

The footer identity becomes `李唯礽｜GEO 實驗與研究紀錄`; its two links use the same navigation labels.

- [ ] **Step 3: Replace the case copy without changing its structure**

Keep the existing classes, wrappers, video, and iframe attributes. Replace only the case metadata and copy with:

```html
<div class="case-first-meta">
  <span class="lab-index">Research Note / 01</span>
  <span class="evidence-badge">生成式搜尋觀察</span>
</div>

<h1>一次 GEO 實驗的<br>觀察紀錄</h1>

<p class="case-lead">
  這是我針對一個小型、低權重網站進行的 GEO 實作觀察，想理解內容結構與技術設定，是否能提高網站被搜尋引擎與生成式 AI 辨識的機會。
</p>

<div class="case-evidence-copy">
  <span class="case-evidence-label">這次查詢觀察到什麼</span>
  <strong>這次查詢中，這個網站出現於 AI 摘要中。</strong>

  <p>
    影片記錄查詢關鍵字後，生成式搜尋整理出的 AI 摘要。
    這個結果提供了一次可觀察的紀錄，但不代表每次查詢都會出現相同答案。
  </p>

  <p>
    生成式搜尋的回應具有機率性，結果也可能隨時間、查詢方式與系統更新而改變。
    因此我把這次結果視為研究過程中的一筆證據，並持續觀察內容被理解、收錄與引用的條件。
  </p>
</div>
```

- [ ] **Step 4: Replace the biography while retaining the portrait and skill tags**

Change the portrait alt to `進行 GEO 與生成式搜尋研究的李唯礽個人照片`, the eyebrow to `About the Research`, and the heading/body to:

```html
<h2>
  我如何研究 GEO
</h2>

<p>
  我目前就讀資料科學系，持續研究 GEO、AEO 與生成式搜尋。
  我特別想了解：對剛上線或網域權重較低的網站來說，內容結構、技術設定與網站本身的可信度，會如何影響它被搜尋引擎與生成式 AI 理解、收錄及引用的機會。
</p>

<p>
  為了驗證這些問題，我不只閱讀資料，也會實際建置網站、整理內容架構，
  並透過 Search Console、GA4、網站收錄狀態與結構化資料觀察變化。
  Next.js、HTML／CSS 與網站分析，是我把研究問題變成可測試成果的方法。
</p>

<p>
  我的做法通常是先釐清問題，再把內容、技術與數據分開記錄。
  一次被 AI 摘要引用不代表穩定成功，但每次可重現或不可重現的結果，
  都能幫助我更接近生成式搜尋如何理解網站的答案。
</p>
```

Leave all eight existing `<span class="skill">` elements and their text unchanged.

- [ ] **Step 5: Run the complete static contract**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: exit code `0` and `PASS: case-and-about-only structural checks`.

- [ ] **Step 6: Commit the page reframe**

```powershell
git add -- index.html
git commit -m "content: reframe site around GEO research"
```

---

### Task 3: Verify Layout and Final Consistency

**Files:**
- Modify only if needed: `index.html` embedded CSS
- Test: `tests/site-checks.ps1`

**Interfaces:**
- Consumes: The completed researcher-positioned page from Task 2 and the existing responsive styles.
- Produces: A visually verified desktop and 390px mobile page with no content overflow, overlap, broken media, or residual sales framing.

- [ ] **Step 1: Start the local site**

Run:

```powershell
node tests/static-server.cjs
```

Expected: the static server listens on its configured localhost port and serves `index.html`.

- [ ] **Step 2: Inspect desktop layout**

Open the local page at a `1440x1000` viewport. Confirm:

- the page still contains only the case and about sections;
- the first section remains left-copy/right-video;
- the video loads in the existing frame and keeps its 16:9 ratio;
- the case heading and paragraphs do not collide with the video or overflow;
- the about section remains left-image/right-copy;
- navigation and footer both show `研究紀錄` and `關於我`.

- [ ] **Step 3: Inspect mobile layout**

Open the same page at a `390x844` viewport. Confirm:

- the order remains research metadata, heading, lead, video, evidence copy, then about;
- no horizontal scrollbar, clipped text, overlap, or unreadable line wrapping appears;
- the menu opens, closes, and scrolls to both anchors;
- the portrait remains correctly cropped and its caption remains readable.

If and only if a copy-induced regression is visible, adjust existing typography or spacing rules in `index.html`; do not introduce a new layout or visual system.

- [ ] **Step 4: Scan for residual sales language and validate the diff**

Run:

```powershell
rg -n "成功案例|我們團隊|施作|中小企業 GEO 網站優化|網站優化服務者" index.html
git diff --check
powershell -ExecutionPolicy Bypass -File tests/site-checks.ps1
```

Expected: `rg` returns no matches, `git diff --check` returns no errors, and the static checks pass.

- [ ] **Step 5: Commit any necessary visual adjustment**

If Step 3 required a CSS change:

```powershell
git add -- index.html
git commit -m "style: preserve layout with research copy"
```

If no CSS change was needed, do not create an empty commit.
