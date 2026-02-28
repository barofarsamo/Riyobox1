## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Video Player Controls and Slider UX]
**Learning:** Adding `divisions` and `label` to a `Slider` provides immediate, discrete feedback (e.g., percentages), which is a reusable UX pattern for controls like volume or brightness. Since Flutter's `Slider` lacks a `semanticLabel`, wrapping it in `Semantics` is necessary for screen reader accessibility. Dynamic tooltips on toggle buttons (Play/Pause) improve clarity by reflecting the next action.
**Action:** Use `divisions: 100` and percentage labels for sliders. Wrap sliders in `Semantics`. Implement dynamic tooltips for state-toggling buttons.
