## 2025-05-15 - Improving Accessibility with Tooltips and Semantic Labels
**Learning:** Many `IconButton` and `Image.network` widgets in this project are missing `tooltip` and `semanticLabel` properties, which are critical for screen reader accessibility and general UX. For buttons that toggle state (like Play/Pause), a dynamic tooltip provides even better clarity.
**Action:** Always check for missing `tooltip` on `IconButton` and `semanticLabel` on `Image` widgets. For toggle buttons, implement dynamic tooltips that reflect the next action.
