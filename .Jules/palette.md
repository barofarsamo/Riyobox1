## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Redundant Semantics and Ripple Patterns]
**Learning:** In Flutter, the `Tooltip` widget automatically provides a semantic label to its child, making an additional `Semantics` wrapper with the same text redundant. For interactive image cards, a `Stack` with a `Positioned.fill` `InkWell` (wrapped in a transparent `Material`) is the most reliable way to provide ripple feedback over opaque children like `Image.network`.
**Action:** Avoid nesting `Semantics` inside `Tooltip` for the same label. Use the `Stack` + `Positioned.fill` `Material` + `InkWell` pattern for interactive cards with rounded corners, ensuring `borderRadius` is applied to all relevant layers.
