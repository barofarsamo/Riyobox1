## 2025-05-14 - [Recurring Pattern: Missing Tooltips]
**Learning:** In this Flutter project, many `IconButton` widgets are missing the `tooltip` property. This is a recurring accessibility issue that prevents screen reader users from understanding the purpose of icon-only buttons.
**Action:** Always check for and add a descriptive `tooltip` to `IconButton` widgets. Ensure that tooltips for toggle buttons (like Play/Pause) update dynamically to reflect the next action.
