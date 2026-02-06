## 2025-02-06 - Accessibility Tooltips and Semantic Labels
**Learning:** Found a systemic lack of `tooltip` on `IconButton` and `semanticLabel` on `Image.network` widgets. These are essential for screen reader users to identify the purpose of controls and content of images.
**Action:** Always include `tooltip` for icon-only buttons and `semanticLabel` for informative images (like movie posters) in Flutter projects to ensure a baseline of accessibility.

## 2025-02-06 - Mocking Network Images in Flutter Tests
**Learning:** Flutter tests using `NetworkImage` will fail with 400 errors unless `HttpOverrides` is used to mock the `HttpClient`. `noSuchMethod` is a powerful tool to create minimal mocks of complex internal classes like `HttpClientResponse`.
**Action:** Use a reusable `MockHttpOverrides` in test suites that pump widgets containing `NetworkImage` to avoid CI failures and flakes.
