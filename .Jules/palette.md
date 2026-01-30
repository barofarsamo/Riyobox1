## 2025-05-15 - [Accessibility Gaps in Icon Buttons and Images]
**Learning:** In Flutter applications, icon-only buttons (IconButton) without a 'tooltip' and images (Image.network) without a 'semanticLabel' are completely opaque to screen reader users. The 'tooltip' property is particularly valuable as it provides both a visual hint for sighted users and a label for accessibility.
**Action:** Always check for missing tooltips on icon buttons and missing semantic labels on informative images. Every interactive element must have a text-based description.
