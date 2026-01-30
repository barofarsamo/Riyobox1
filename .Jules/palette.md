## 2025-05-15 - [Accessibility Gaps in Icon Buttons and Images]
**Learning:** In Flutter applications, icon-only buttons (IconButton) without a 'tooltip' and images (Image.network) without a 'semanticLabel' are completely opaque to screen reader users. The 'tooltip' property is particularly valuable as it provides both a visual hint for sighted users and a label for accessibility.
**Action:** Always check for missing tooltips on icon buttons and missing semantic labels on informative images. Every interactive element must have a text-based description.

## 2025-05-15 - [Handling Blocking CI Failures in Tests]
**Learning:** Sometimes pre-existing test failures can block PRs for small UX improvements. In Flutter, NetworkImageLoadException is a common cause of test failures when real images are used in the app but not mocked in tests.
**Action:** Use 'tester.pump()' and 'tester.takeException()' in widget tests to safely handle expected network failures during integration tests if a full mock setup is out of scope.
