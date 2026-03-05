## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Flutter Material Ripple and Opaque Backgrounds]
**Learning:** In Flutter, an `InkWell` splash effect is hidden if its child or parent is a `Container` with an opaque `color` or `decoration`.
**Action:** To ensure visible ripple effects on colored widgets, wrap the `InkWell` (with `customBorder`) inside a `Material` widget that has the desired `color` and `shape` (e.g., `CircleBorder`). For images, use a `Stack` with the `InkWell` in a `Positioned.fill` on top of the image.
