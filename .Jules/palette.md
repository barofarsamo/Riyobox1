## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Slider Accessibility and Feedback]
**Learning:** The Flutter `Slider` widget lacks a `semanticLabel` property; to provide a label for screen readers, it must be wrapped in a `Semantics` widget. Additionally, for percentage-based controls like volume, using `divisions: 100` with a formatted `label` improves both precision and clarity.
**Action:** Wrap `Slider` in `Semantics` for accessibility and always provide `divisions` and `label` for discrete feedback.
