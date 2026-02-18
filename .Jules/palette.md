## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-02-18 - [Flutter Accessibility and Const Widgets]
**Learning:** `Semantics` is not a `const` constructor, so its children cannot be treated as `const` by parent widgets like `Padding`. However, `CircleAvatar` and `NetworkImage` are `const`, so they should be marked `const` within `Semantics` to satisfy linting rules.
**Action:** Use `const` selectively for children of `Semantics` when possible, and avoid marking the parent of `Semantics` as `const` if it's the immediate parent.
