## 2025-05-14 - [Accessibility Improvements for Images and IconButtons]
**Learning:** IconButton widgets without tooltips and Image.network widgets without semanticLabels are common accessibility gaps in this Flutter codebase. Screen reader users cannot identify the purpose of these elements without these properties.
**Action:** Always check for missing tooltip on IconButton and semanticLabel on Image.network when touching UI components.

## 2025-05-14 - [Flutter Web Verification with Playwright]
**Learning:** When verifying Flutter Web with Playwright, interactive elements with ARIA labels may not appear in the DOM unless the 'Enable accessibility' button in the Flutter Semantics layer is triggered. Standard click() might fail if the placeholder is reported as off-screen.
**Action:** Use dispatch_event('click') on the flt-semantics-placeholder to reliably enable accessibility for automated verification.
