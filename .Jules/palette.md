## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-02-25 - [Video Player Accessibility and Feedback]
**Learning:** For `Slider` widgets representing percentages (like volume or brightness), use `divisions: 100` and `label: '${(value * 100).round()}%'` to provide discrete and readable user feedback. Wrapping `Slider` in `Semantics` is necessary as it lacks a native `semanticLabel` property.
**Action:** Always add tooltips to video controls and provide granular feedback for range-based sliders using `divisions` and `label`.
