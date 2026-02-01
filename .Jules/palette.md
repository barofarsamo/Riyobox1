## 2025-05-14 - Accessibility Gaps in Icon-Only Buttons and Images
**Learning:** In Flutter applications, `IconButton` widgets without a `tooltip` and `Image.network` widgets without a `semanticLabel` are common accessibility oversights that significantly hinder screen reader users. Tooltips also provide helpful hover feedback on web/desktop.
**Action:** Always check for missing `tooltip` on `IconButton` and `semanticLabel` on informative images. For stateful buttons (like Play/Pause), ensure the tooltip dynamically reflects the current state.
