## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2025-01-24 - [Enhanced Video Player Accessibility and Feedback]
**Learning:** Adding `divisions` and `label` to `Slider` widgets provides essential discrete feedback for controls like volume and brightness. Consistent tooltips for playback controls (Rewind, Play/Pause, Fast Forward) are crucial for both accessibility and user confidence.
**Action:** Always include `divisions: 100` and a percentage-based `label` on `Slider` widgets representing normalized values (0.0 to 1.0). Ensure every playback control has a descriptive, dynamic tooltip.
