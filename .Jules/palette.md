## 2024-07-15 - Images Must Have Semantic Labels

**Learning:** `Image.network` and `Image.asset` widgets, when used to convey information, must have a `semanticLabel` property. Without it, screen readers cannot describe the image to visually impaired users, making the app inaccessible. This is a recurring issue in this codebase.

**Action:** For every `Image.network` or `Image.asset` widget I encounter, I will check if it has a `semanticLabel` and add a descriptive one if it's missing. The label should be concise and accurately describe the image's content or purpose.
