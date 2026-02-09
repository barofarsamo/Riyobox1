## 2026-02-09 - Accessibility of Flutter Web Components
**Learning:** In Flutter Web builds, accessibility metadata like `tooltip` and `semanticLabel` are crucial for screen readers but manifest differently in the DOM. `tooltip` on `IconButton` becomes text content of semantics nodes, while `semanticLabel` on `Image.network` becomes an `aria-label`. These only appear in the semantics tree after clicking the 'Enable accessibility' placeholder.
**Action:** Always verify accessibility by enabling the semantics layer in Flutter Web and checking for these specific attributes/text in Playwright.

## 2026-02-09 - Screen Navigation and Verification
**Learning:** The initial screen in this app is set to index 1 (Category) instead of 0 (Home), which can lead to confusion during automated verification if not accounted for.
**Action:** Explicitly navigate to the intended screen by interacting with the `BottomNavigationBar` semantics nodes before performing assertions on screen-specific widgets.
