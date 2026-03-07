## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Flutter Interactivity and Const Constraints]
**Learning:** Wrapping widgets in `Semantics` or `InkWell` often breaks `const` optimizations because these widgets (or their specific configurations) lack `const` constructors. Additionally, standard `InkWell` ripples are obscured by opaque children like `Image` or `Container` with colors.
**Action:** Remove `const` keywords from parent widgets when introducing accessibility or interactivity wrappers. Use the `Stack` + `Positioned.fill` + `Material(color: Colors.transparent)` pattern to ensure ripples are visible over images. For circular buttons, apply `CircleBorder()` to both the `Material` shape and the `InkWell` customBorder.
