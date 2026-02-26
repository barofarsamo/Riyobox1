## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2026-02-26 - [Flutter Semantics and Const Constraints]
**Learning:** The `Semantics` widget in Flutter does not have a `const` constructor. When wrapping `const` widgets (like a `CircleAvatar` with a `NetworkImage`) in `Semantics`, the parent's `const` keyword must be removed or moved to the child widget to avoid compilation errors.
**Action:** Always check for `const` at the parent level when adding `Semantics` and move it down to child constructors where applicable.
