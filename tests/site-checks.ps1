$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $projectRoot 'index.html'
$html = Get-Content -Raw -Encoding utf8 $indexPath
$failures = New-Object System.Collections.Generic.List[string]
$expected = @{}

Get-Content -Encoding utf8 (Join-Path $PSScriptRoot 'expected-content.txt') | ForEach-Object {
  $parts = $_.Split("`t", 2)
  $expected[$parts[0]] = $parts[1]
}

function Assert-Contains([string]$needle, [string]$message) {
  if (-not $script:html.Contains($needle)) {
    $script:failures.Add($message)
  }
}

function Assert-NotContains([string]$needle, [string]$message) {
  if ($script:html.Contains($needle)) {
    $script:failures.Add($message)
  }
}

function Assert-ContainsInSection([string]$sectionId, [string]$needle, [string]$message) {
  $pattern = '(?s)<section[^>]+id="' + [regex]::Escape($sectionId) + '".*?</section>'
  $match = [regex]::Match($script:html, $pattern)
  if (-not $match.Success -or -not $match.Value.Contains($needle)) {
    $script:failures.Add($message)
  }
}

function Assert-Count([string]$pattern, [int]$expectedCount, [string]$message) {
  $actual = [regex]::Matches($script:html, $pattern).Count
  if ($actual -ne $expectedCount) {
    $script:failures.Add("$message Expected $expectedCount, found $actual.")
  }
}

Assert-Count '<section\b' 2 'Main content must contain exactly two sections.'
Assert-Count 'id="case-study"' 1 'The success case section must remain exactly once.'
Assert-Count 'id="about"' 1 'The personal introduction section must remain exactly once.'

foreach ($removedId in @('home', 'geo', 'services', 'process', 'faq')) {
  Assert-NotContains ('id="' + $removedId + '"') "Removed section #$removedId is still present."
  Assert-NotContains ('href="#' + $removedId + '"') "Navigation still links to removed section #$removedId."
}

Assert-Contains '<a class="logo" href="#case-study"' 'Logo must return to the success case.'
$caseLink = '<a href="#case-study">' + $expected['nav_case'] + '</a>'
$aboutLink = '<a href="#about">' + $expected['nav_about'] + '</a>'
Assert-Contains $caseLink 'Navigation must link to the success case.'
Assert-Contains $aboutLink 'Navigation must link to the personal introduction.'
Assert-Count ([regex]::Escape($caseLink)) 2 'Header and footer must both link to the success case.'
Assert-Count ([regex]::Escape($aboutLink)) 2 'Header and footer must both link to the personal introduction.'

Assert-ContainsInSection 'case-study' $expected['case_copy'] 'Approved case-study evidence copy must remain.'
Assert-ContainsInSection 'case-study' $expected['case_heading'] 'Case-study heading must remain.'
Assert-ContainsInSection 'case-study' $expected['case_evidence_heading'] 'Case-study evidence label must remain.'
Assert-ContainsInSection 'case-study' $expected['case_evidence_copy'] 'Case-study citation evidence must remain.'
Assert-ContainsInSection 'case-study' $expected['case_probability'] 'Case-study probability disclaimer must remain.'
Assert-ContainsInSection 'case-study' $expected['case_probability_action'] 'Case-study GEO disclaimer must remain.'
Assert-ContainsInSection 'case-study' 'Research Note / 01' 'Case-study index must identify a research note.'
Assert-ContainsInSection 'case-study' '生成式搜尋觀察' 'Case-study badge must frame the result as an observation.'
Assert-ContainsInSection 'case-study' '這次查詢中，這個網站出現於 AI 摘要中。' 'Case-study evidence must state the observed result precisely.'
Assert-Contains 'https://www.youtube-nocookie.com/embed/6hwyCr4K378?rel=0' 'Case-study video must remain.'

Assert-ContainsInSection 'about' $expected['about_heading'] 'Personal introduction heading must remain.'
Assert-ContainsInSection 'about' $expected['about_copy'] 'Approved biography must remain.'
Assert-ContainsInSection 'about' '為了驗證這些問題，我不只閱讀資料，也會實際建置網站、整理內容架構' 'Biography must connect practical work to research.'
Assert-Contains 'assets/about-photo.jpg' 'Portrait asset must remain.'
Assert-Count '<span class="skill">' 8 'All eight skill tags must remain.'

Assert-Contains 'application/ld+json' 'Person structured data must remain.'
Assert-Contains '"@type": "Person"' 'Person structured data must remain.'
Assert-Contains '<title>GEO 實驗與生成式搜尋研究｜個人研究紀錄</title>' 'Document title must use the researcher positioning.'
Assert-Contains '"jobTitle": "資料科學學生與 GEO 研究實作者"' 'Person structured data must use the researcher positioning.'
Assert-NotContains '"@type": "Service"' 'Service structured data must be removed with the service section.'

foreach ($salesPhrase in @('成功案例', '我們團隊', '施作', '中小企業 GEO 網站優化', '網站優化服務者')) {
  Assert-NotContains $salesPhrase ('Sales-oriented phrase remains: ' + $salesPhrase)
}

Assert-Contains '<a class="skip-link" href="#main-content">' 'Keyboard users need a skip-to-content link.'
Assert-Contains '<main id="main-content">' 'Main content must expose a skip-link target.'
Assert-Contains 'aria-controls="navLinks"' 'Menu button must identify the controlled navigation.'
Assert-Contains '<span class="menu-line"></span>' 'Menu button must retain CSS icon lines.'
Assert-Contains $expected['menu_label_expression'] 'Menu state must update its accessible label.'
Assert-Contains '@media (prefers-reduced-motion: reduce)' 'Reduced-motion support must remain.'
Assert-Contains '@media (max-width: 640px)' 'Small-screen breakpoint must remain.'
Assert-Contains 'overflow-x: clip;' 'Horizontal overflow safeguard must remain.'
Assert-Contains '--case-container: 1560px;' 'Expanded case container token must remain at 1560px.'
Assert-Contains 'grid-template-columns: minmax(0, 0.6fr) minmax(0, 1.4fr);' 'Desktop case grid must allocate 70 percent to video.'
Assert-Contains '@media (max-width: 1024px)' 'Tablet breakpoint must remain.'
Assert-Contains 'width: min(calc(100% - 28px), var(--case-container));' 'Mobile case gutter must remain 14px per side.'
Assert-Contains 'color: #d7e0ee;' 'Case lead must use the approved brighter color.'
Assert-Contains 'font-size: clamp(1.06rem, 1.5vw, 1.18rem);' 'Case lead must use the approved larger size.'
Assert-Contains 'font-weight: 600;' 'Case lead must use the approved semibold weight.'
Assert-Contains 'color: #cbd6e8;' 'Case evidence copy must use the approved brighter color.'
Assert-Contains 'font-size: 0.96rem;' 'Case evidence copy must use the approved larger size.'
Assert-Contains 'font-weight: 550;' 'Case evidence copy must use the approved medium weight.'

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  exit 1
}

Write-Output 'PASS: case-and-about-only structural checks'
