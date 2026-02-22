## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-02-22 - [Interactive Slider Feedback and CircleAvatar Tooltips]
**Learning:** `CircleAvatar` lacks a `tooltip` property, which must be implemented via a `Tooltip` wrapper or `Semantics`. Adding `label` and `divisions` to `Slider` widgets significantly improves tactile and visual feedback for numeric controls like volume or brightness.
**Action:** When enhancing sliders, always include `label` and `divisions` for discrete feedback. Ensure `IconButton` tooltips in video players are dynamic to reflect the toggled state.
