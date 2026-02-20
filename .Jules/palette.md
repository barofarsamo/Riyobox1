## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Dynamic Tooltips for Playback Controls]
**Learning:** For buttons that toggle state (e.g., Play/Pause), tooltips should dynamically update to reflect the next action for better accessibility and user clarity.
**Action:** Use ternary operators or state-dependent strings for `tooltip` properties in stateful toggle buttons.
