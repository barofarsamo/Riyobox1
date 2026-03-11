## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-03-11 - [Material Ripple on Decorated Containers]
**Learning:** In Flutter, 'InkWell' ripple effects are often hidden by 'Container' decorations. Using 'Material' -> 'Ink' (for decoration) -> 'InkWell' ensures that ripples are rendered on top of gradients or background colors.
**Action:** When adding interactivity to decorated boxes, use 'Ink' for the decoration and wrap the 'InkWell' inside it, ensuring both have matching 'borderRadius'.
