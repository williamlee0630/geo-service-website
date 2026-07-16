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
Assert-Contains $expected['case_copy'] 'Approved case-study evidence copy must be preserved.'
Assert-Contains $expected['case_heading'] 'Original case-study heading must be preserved.'
Assert-Contains $expected['case_evidence_heading'] 'Original case-study evidence label must be preserved.'
Assert-Contains $expected['limitation'] 'Result limitation statement must be preserved.'
Assert-Contains $expected['service_heading'] 'Service section must use the approved outcome-oriented heading.'
Assert-Contains $expected['service_1'] 'Service card 1 heading is missing.'
Assert-Contains $expected['service_2'] 'Service card 2 heading is missing.'
Assert-Contains $expected['service_3'] 'Service card 3 heading is missing.'
Assert-Contains $expected['service_4'] 'Service card 4 heading is missing.'
Assert-NotContainsInSection 'services' $expected['removed_1'] 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' $expected['removed_2'] 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' $expected['removed_3'] 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' $expected['removed_4'] 'Service section reveals implementation checklist details.'
Assert-NotContainsInSection 'services' $expected['removed_5'] 'Service section reveals implementation checklist details.'
Assert-Count 'id="advantages"' 0 'Competitive Advantages section must be removed.'
Assert-Count ([regex]::Escape($expected['advantage_heading'])) 0 'Competitive Advantages heading must be removed.'
Assert-Count '(?s)<section[^>]+id="services"(?:(?!<section).)*?</section>\s*<!-- Process -->\s*<section[^>]+id="process"' 1 'Services must flow directly into the process section.'
Assert-Count '<details class="faq-item"' 8 'All eight FAQ items must remain.'
Assert-Count '<span class="skill">' 8 'All eight skill tags must remain.'
Assert-Contains 'assets/about-photo.jpg' 'Portrait asset must remain.'
Assert-Contains 'application/ld+json' 'JSON-LD must remain.'
Assert-Contains 'property="og:title"' 'Open Graph title must remain.'
Assert-Contains '--lab-ink: #07111f;' 'Research Lab ink token is missing.'
Assert-Contains '--lab-accent: #86a7ff;' 'Research Lab accent token is missing.'
Assert-Contains '.case-first-grid {' 'Case-first desktop grid styles are missing.'
Assert-Contains '.research-thesis-grid {' 'Research thesis layout styles are missing.'
Assert-Contains '@media (prefers-reduced-motion: reduce)' 'Reduced-motion support is missing.'
Assert-Contains '@media (max-width: 640px)' 'Small-screen breakpoint is missing.'
Assert-Contains 'overflow-x: clip;' 'Horizontal overflow safeguard is missing.'
Assert-Contains 'aria-controls="navLinks"' 'Menu button must identify the controlled navigation.'
Assert-Contains '<span class="menu-line"></span>' 'Menu button must use stable CSS icon lines.'
Assert-Contains $expected['menu_label_expression'] 'Menu state must update its accessible label.'
Assert-Contains '<a class="logo" href="#case-study"' 'Logo must return to the case-first top section.'
Assert-Contains '<a class="skip-link" href="#main-content">' 'Keyboard users need a skip-to-content link.'
Assert-Contains '<main id="main-content">' 'Main content must expose a skip-link target.'
Assert-Contains '--case-container: 1260px;' 'Expanded case container token is missing.'
Assert-Contains 'grid-template-columns: minmax(0, 0.72fr) minmax(0, 1.28fr);' 'Desktop case grid must allocate 64 percent to video.'
Assert-Contains 'width: min(calc(100% - 28px), var(--case-container));' 'Mobile case gutter must remain 14px per side.'

if ($html.Contains($expected['menu_open_symbol']) -or $html.Contains($expected['menu_close_symbol'])) {
  $failures.Add('Structural UI must not use Emoji menu icons.')
}

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  exit 1
}

Write-Output 'PASS: structural and content checks'
