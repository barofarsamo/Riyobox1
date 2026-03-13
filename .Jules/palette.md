## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-06-05 - [Interactive Feedback for Profile Stats]
**Learning:** Statistics items and profile action buttons often lack visual feedback (ripples) and descriptive tooltips in "My Profile" type screens, making them feel static. Wrapping these in `InkWell` with a subtle `borderRadius` and adding tooltips provides immediate interactive feedback and improves discoverability.
**Action:** Always check profile-style screens for "stat cards" or "summary items" and ensure they provide material ripples and descriptive tooltips.
