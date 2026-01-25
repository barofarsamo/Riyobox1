## 2024-05-20 - Missing `semanticLabel` on `Image.network` widgets
**Learning:** `Image.network` widgets across the app are missing the `semanticLabel` property. This is a critical accessibility issue, as it prevents screen readers from describing the image's purpose to visually impaired users.
**Action:** Proactively inspect all `Image.network` widgets for a missing `semanticLabel` and add a descriptive label, typically the movie's title, to ensure screen reader compatibility.
