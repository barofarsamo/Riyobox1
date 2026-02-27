## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-02-27 - [Enhanced Video Player UX and Accessibility]
**Learning:** Adding tooltips to icon-only media controls and wrapping Sliders in Semantics with percentage labels and divisions significantly improves both visual feedback and screen reader accessibility. Discrete divisions (e.g., 100) on sliders for volume and brightness make the interface feel more precise and professional.
**Action:** Always provide tooltips for playback controls and use Semantics with descriptive labels for Sliders. Implement discrete labels on Sliders to provide immediate, readable state feedback.
