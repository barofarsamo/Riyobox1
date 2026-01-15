## 2024-07-22 - Missing semanticLabels on Image.network
**Learning:** I've identified a recurring accessibility issue where `Image.network` widgets are used without a `semanticLabel` property. This leaves images without a text alternative for screen reader users, making the app less accessible.
**Action:** In the future, I will make sure to audit `Image.network` instances and add a descriptive `semanticLabel` whenever one is missing.
