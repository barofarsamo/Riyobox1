## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Flutter Widget Layering and Semantic Redundancy]
**Learning:** In Flutter, `Tooltip` widgets automatically provide semantic labels to screen readers, rendering additional `Semantics` wrappers redundant for simple labeling. Visually, `InkWell` splash effects are drawn on the nearest `Material` ancestor and are obscured by opaque children like `Image`.
**Action:** Avoid nesting `Semantics` inside `Tooltip` for plain text labels. For ripples on images, use `Ink.image` or overlay the `InkWell` on top of the image within a `Stack` using a `Positioned.fill` and a transparent `Material` widget.
