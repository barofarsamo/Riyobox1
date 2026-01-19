# Palette's Journal

This journal is for logging critical UX/accessibility learnings discovered while working on this project.

## 2024-05-20 - `Image.network` widgets missing `semanticLabel`

**Learning:** `Image.network` widgets without a `semanticLabel` are invisible to screen readers, making the app less accessible. This is a common issue in Flutter development.

**Action:** Always provide a `semanticLabel` for `Image.network` widgets, especially in reusable components. The label should be descriptive and based on the image's content.
