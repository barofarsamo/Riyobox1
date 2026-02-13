## 2025-05-14 - Optimizing Card Semantics
**Learning:** When a card contains both an image and a text label (like a movie title), providing a semantic label for both creates redundancy for screen readers. It's better to wrap the entire component in a single `Semantics` group or use `MergeSemantics` to provide a cohesive description while excluding internal decorative or redundant elements.
**Action:** Use `MergeSemantics` for simple cards or a `Semantics` wrapper with `ExcludeSemantics` on children for complex components to ensure a single, clear announcement.
