# Further Enlarge Case Video Design

## Goal

Make the case-study video materially larger on desktop while preserving the current case-first composition, copy, section order, and responsive behavior.

## Approved Direction

Use the selected Option B: retain the side-by-side desktop layout, increase the case container maximum from `1260px` to `1360px`, and allocate 70% of the post-gap grid width to the video with `0.6fr / 1.4fr` columns.

At the maximum desktop container width, this changes the approximate video width from 760px to 902px, an increase of about 18.6%.

## Scope

- Change only the case-study sizing tokens and desktop grid ratio.
- Keep the existing markup, video embed, copy, visual styling, section order, and navigation unchanged.
- Keep the layout single-column at `1024px` and below.
- Keep the small-screen case width at `calc(100% - 28px)`.
- Add regression assertions for the approved desktop and mobile sizing contracts.

## Verification

- Static checks must assert `--case-container: 1360px`, the `0.6fr / 1.4fr` desktop grid, the existing `1024px` single-column breakpoint, and the 28px mobile gutter.
- Existing structural and approved-copy checks must continue to pass.
- Render the local page at representative desktop and mobile widths and inspect for overflow, clipping, overlap, or unintended responsive changes.

## Out of Scope

- Rewriting case-study content.
- Changing the iframe source or aspect ratio.
- Redesigning the mobile layout.
- Refactoring unrelated site styles.
