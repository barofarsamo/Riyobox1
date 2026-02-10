# Palette's Journal - Critical UX/Accessibility Learnings

## 2025-05-15 - [Dynamic Tooltips for Toggle Buttons]
**Learning:** For buttons that toggle state (like Play/Pause), providing a dynamic tooltip that reflects the *action* (e.g., "Play" when paused) is essential for clarity.
**Action:** Always use ternary operators or similar logic for tooltips on toggle buttons.

## 2025-05-15 - [Clearing Network Image Exceptions in Tests]
**Learning:** Flutter widget tests that include `Image.network` will throw `NetworkImageLoadException` in environments without internet. These exceptions can be cleared using `while (tester.takeException() != null) {}` to allow tests to pass.
**Action:** Use this pattern in `test/widget_test.dart` when dealing with unmocked network images.
