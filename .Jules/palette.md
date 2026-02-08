## 2026-02-08 - [IconButton Tooltips in Flutter Web]
**Learning:** In Flutter Web, the 'tooltip' property on an IconButton is rendered as the direct text content of the 'flt-semantics' node (role="button"), whereas 'semanticLabel' on an Image is rendered as an 'aria-label' attribute on a 'flt-semantics' node (role="img").
**Action:** When verifying accessibility in Flutter Web with Playwright, check the text content of button semantic nodes for tooltips, and the aria-label attribute of image semantic nodes for semantic labels.
