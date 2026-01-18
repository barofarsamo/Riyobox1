## 2024-05-21 - Add semanticLabel to Image.network
**Learning:** `Image.network` widgets in this codebase frequently lack `semanticLabel` properties. This is a critical accessibility issue, as it prevents screen readers from effectively describing images to visually impaired users.
**Action:** Always check for and add `semanticLabel` to any `Image.network` widgets that are added or modified. The label should be descriptive and based on the image's content or purpose. For the movie cards, the movie title is an effective label.
