# Palette's Journal - UX & Accessibility Learnings

## 2025-05-14 - [A11y patterns for Flutter content-heavy apps]
**Learning:** In Flutter apps that use `NestedScrollView` and `SliverAppBar` for branding (like Netflix clones), the app title is often split or custom-styled, making simple `find.text` matches in tests brittle. Always use `find.textContaining` or `find.byType(Text)` with specific predicates for more robust UI tests. Additionally, `IconButton` widgets in this codebase consistently lack `tooltip` properties, which is a significant barrier for screen reader users who need to know the button's action before interacting.

**Action:** When working with slivers or custom app bars, verify accessibility labels for all icon-only actions and use flexible text matchers in tests. Ensure every `IconButton` has a `tooltip` and every `Image.network` has a `semanticLabel`.
