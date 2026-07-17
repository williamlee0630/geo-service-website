# Case Small Copy Emphasis Design

## Goal

Make the small supporting text in the case-study copy column easier to notice and read without changing the section composition or making the evidence block visually heavy.

## Approved Direction

Use the selected Visual Companion Option A, “Clear and Bright.” Increase contrast and typographic weight only:

- Brighten `.case-lead` from `#bdc8dc` to `#d7e0ee`, change its size from `clamp(1rem, 1.45vw, 1.14rem)` to `clamp(1.06rem, 1.5vw, 1.18rem)`, and add a `600` font weight.
- Brighten `.case-evidence-copy p` from `#aebbd2` to `#cbd6e8`, raise its size from `0.91rem` to `0.96rem`, and add a `550` font weight.
- Keep current line heights so the denser text remains comfortable to scan.

## Scope

- Change only `.case-lead` and `.case-evidence-copy p` typography.
- Keep all text, markup, spacing, labels, headings, colors outside these two selectors, video sizing, and responsive layout unchanged.
- Apply the same enhanced typography at every viewport.

## Verification

- Add static assertions for the approved colors, sizes, and weights.
- Existing structural, copy, video-sizing, breakpoint, and accessibility checks must continue to pass.
- Confirm the resulting CSS changes only the two approved selectors.

## Out of Scope

- Adding a panel, border, badge, or new decoration.
- Rewriting text.
- Changing the video or section layout.
- Refactoring unrelated styles.
