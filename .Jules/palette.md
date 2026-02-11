## 2025-05-15 - Improving Accessibility with Tooltips and Semantic Labels
**Learning:** Many `IconButton` and `Image.network` widgets in this project are missing `tooltip` and `semanticLabel` properties, which are critical for screen reader accessibility and general UX. For buttons that toggle state (like Play/Pause), a dynamic tooltip provides even better clarity.
**Action:** Always check for missing `tooltip` on `IconButton` and `semanticLabel` on `Image` widgets. For toggle buttons, implement dynamic tooltips that reflect the next action.

## 2025-05-15 - Handling NetworkImageLoadException in Widget Tests
**Learning:** Widget tests that use `Image.network` often fail in test environments with `NetworkImageLoadException` (status code 400) because they cannot make real network requests.
**Action:** Use `while (tester.takeException() != null) {}` after `tester.pump()` or `tester.pumpAndSettle()` to clear these expected exceptions from the test framework's error stack, allowing the test to pass if the failure is solely due to the missing network.
