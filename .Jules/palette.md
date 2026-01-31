## 2025-05-14 - Accessibility Gaps in Interactive Widgets
**Learning:** In this Flutter codebase, `IconButton` widgets often lack the `tooltip` property, and `Image.network` widgets often lack `semanticLabel`. This makes the app less accessible for screen reader users and misses out on helpful hover/long-press hints.
**Action:** Always check for missing `tooltip` on `IconButton` and `semanticLabel` on `Image.network` (or other image providers) when working on UI components.
