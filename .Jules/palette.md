## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Visual Feedback for Image-Based Cards]
**Learning:** In Flutter, standard `InkWell` or `GestureDetector` widgets placed as parents of opaque children like `Image.network` do not show ripple effects because the image paints over the splash.
**Action:** Use a `Stack` with `Positioned.fill` containing a `Material` and `InkWell` as the TOPMOST child of the stack to ensure visual feedback is visible to the user.
