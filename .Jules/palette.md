## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Flutter Interactivity and Tooltip Patterns]
**Learning:** `InkWell` ripple effects are obscured by opaque children like `Image.network`. To provide feedback on image-based cards, use a `Stack` with `Positioned.fill` containing a transparent `Material` and the `InkWell`. Additionally, `CircleAvatar` lacks a native `tooltip` property, requiring a `Tooltip` wrapper for hover and accessibility parity with `IconButton`.
**Action:** Apply the `Stack` + `Positioned.fill` + `Material(color: Colors.transparent)` pattern for interactive images. Always wrap profile avatars in `Tooltip` to ensure consistent accessibility across the UI.
