## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Consistent Video Player Tooltips]
**Learning:** Playback toggle buttons require dynamic tooltips to provide accurate state feedback to screen readers and mouse users. Inconsistent application of tooltips across different screens (e.g., Home vs. Categories) can degrade the perceived quality and accessibility of the app.
**Action:** Ensure all `IconButton` instances, especially state-toggling ones like Play/Pause, have a `tooltip` property. Cross-reference `AppBar` actions across screens to maintain consistent labeling for shared controls like 'Settings' or 'Cast'.
