## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-25 - [Video Player Accessibility and Testing]
**Learning:** For buttons that toggle state (e.g., Play/Pause), tooltips should dynamically update to reflect the next action for better accessibility. Testing these in Flutter requires mocking `VideoPlayerPlatform` and adding `video_player_platform_interface` to `dev_dependencies`.
**Action:** Implement dynamic tooltips for toggle buttons. Use `MockVideoPlayerPlatform` in tests to avoid initialization errors.
