# Additional 15% Case Video Enlargement Design

## Goal

Increase the maximum desktop case-study video width by another 15% while preserving the approved side-by-side composition, copy, section order, and responsive behavior.

## Approved Direction

Keep the existing `0.6fr / 1.4fr` desktop grid and raise the case container maximum from `1360px` to `1560px`.

At the maximum container width, the 72px maximum gap leaves 1488px for the grid columns. The video receives 70%, or about 1042px, compared with about 902px previously. This is an increase of about 15.5%.

This approach is preferred over narrowing the text column further or changing to a stacked desktop composition because it enlarges the video without changing the established balance or responsive behavior.

## Scope

- Change `--case-container` from `1360px` to `1560px`.
- Keep the desktop grid at `minmax(0, 0.6fr) minmax(0, 1.4fr)`.
- Keep the single-column breakpoint at `1024px` and below.
- Keep the small-screen case width at `calc(100% - 28px)`.
- Update regression assertions for the new maximum container width.

## Verification

- Static checks must assert `--case-container: 1560px`, the existing desktop grid ratio, the `1024px` single-column breakpoint, and the mobile gutter.
- Existing structure and approved-copy checks must continue to pass.
- Inspect representative desktop and mobile renders for overflow, clipping, overlap, and unintended responsive changes.

## Out of Scope

- Changing the iframe source or aspect ratio.
- Rewriting case-study content.
- Narrowing the text allocation.
- Redesigning tablet or mobile layouts.
- Refactoring unrelated styles.
