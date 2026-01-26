## 2024-07-25 - Recurring Accessibility Issue: Missing semanticLabels on Images

**Learning:** Identified a recurring pattern where `Image.network` widgets are used without a `semanticLabel` property. This makes it difficult for screen readers to convey the purpose of the image to visually impaired users, creating a significant accessibility gap.

**Action:** When adding or modifying images, ensure that a descriptive `semanticLabel` is always included. For existing images, incrementally add the `semanticLabel` property when working on related features.
