## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Video Player Accessibility and Feedback]
**Learning:** Video player controls (Rewind, Fast Forward, Volume/Brightness) are often "invisible" to screen readers if missing labels, and feel imprecise to sighted users without discrete feedback. `IconButton.tooltip` provides both a11y labels and hover hints. Sliders require `Semantics` for context and the `divisions`/`label` properties to provide actionable feedback during adjustment.
**Action:** Always add descriptive tooltips to playback controls (using dynamic labels like "Play"/"Pause"). Wrap sliders in `Semantics` with a descriptive label and use `divisions: 100` with percentage labels for continuous ranges like volume or brightness.
