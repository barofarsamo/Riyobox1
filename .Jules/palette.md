## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Video Player UX and Accessibility]
**Learning:** Adding `divisions` and `label` to `Slider` widgets in Flutter provides immediate discrete feedback, which is particularly useful for media controls like volume and brightness. Combining this with `Semantics` and `Tooltip` on surrounding `IconButton`s ensures a robust accessible experience.
**Action:** Always provide tooltips for playback controls and use discrete labels for percentage-based sliders.
