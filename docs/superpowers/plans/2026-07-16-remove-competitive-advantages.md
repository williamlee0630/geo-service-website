# Remove Competitive Advantages Section Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the entire Competitive Advantages content block so the Services section flows directly into the Process section.

**Architecture:** Keep the existing single-page HTML structure intact and delete only the `#advantages` section node. Extend the current structural PowerShell checks to prevent the removed section and its identifying heading from returning.

**Tech Stack:** Static HTML, CSS, PowerShell structural tests

## Global Constraints

- Remove the complete `#advantages` section, including its eyebrow, heading, description, and six cards.
- Do not add replacement copy or a replacement section.
- Do not modify any other section copy, styling, order, navigation, video, or responsive layout.
- After removal, `#services` must precede `#process` directly in the main page structure.

---

### Task 1: Remove the Competitive Advantages section

**Files:**
- Modify: `tests/expected-content.txt`
- Modify: `tests/site-checks.ps1`
- Modify: `index.html:2134-2187`

**Interfaces:**
- Consumes: Existing `index.html` section IDs and the `$expected` content map loaded from `tests/expected-content.txt`.
- Produces: A page without `#advantages`, protected by structural regression checks.

- [ ] **Step 1: Write the failing structural checks**

Add this line to `tests/expected-content.txt`:

```text
advantage_heading	小型網站怎麼和大型網站競爭
```

Add these assertions after the service-section assertions in `tests/site-checks.ps1`:

```powershell
Assert-Count 'id="advantages"' 0 'Competitive Advantages section must be removed.'
Assert-Count ([regex]::Escape($expected['advantage_heading'])) 0 'Competitive Advantages heading must be removed.'
Assert-Count '(?s)<section[^>]+id="services".*?</section>\s*<!-- Process -->\s*<section[^>]+id="process"' 1 'Services must flow directly into the process section.'
```

- [ ] **Step 2: Run the checks to verify they fail**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\site-checks.ps1
```

Expected: FAIL because `id="advantages"` and the Competitive Advantages heading each appear once.

- [ ] **Step 3: Remove the section from the page**

Delete the complete HTML range beginning with:

```html
    <!-- Competitive advantages -->
    <section class="section" id="advantages">
```

and ending with the matching closing tag immediately before:

```html
    <!-- Process -->
```

Do not change the surrounding Services or Process markup.

- [ ] **Step 4: Run the checks to verify they pass**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests\site-checks.ps1
```

Expected: `PASS: structural and content checks`

- [ ] **Step 5: Review the focused diff**

Run:

```powershell
git diff -- index.html tests/site-checks.ps1 tests/expected-content.txt
```

Expected: Only the Competitive Advantages HTML block is deleted, with three regression assertions and one expected-content entry added.

- [ ] **Step 6: Commit the implementation**

```powershell
git add -- index.html tests/site-checks.ps1 tests/expected-content.txt
git commit -m "refactor: remove competitive advantages section"
```
