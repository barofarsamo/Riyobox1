## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Downloads Screen Empty State UX]
**Learning:** Replacing text placeholders with informative empty states containing icons, clear titles, and call-to-action buttons significantly improves the "finished" feel and navigability of a media application. Consistent AppBars across screens provide familiar navigation and utility access points.
**Action:** Identify and replace simple "Empty" or "Placeholder" screens with structured empty states that guide the user back to core app value.
