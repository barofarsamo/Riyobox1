## 2024-05-24 - [Flutter Web Accessibility and Search UX]
**Learning:** Flutter Web renders tooltips as text in the semantics tree, making them searchable but tricky to verify with standard Playwright role selectors without enabling accessibility. Widget tests often fail due to `NetworkImageLoadException` which can be suppressed globally for cleaner test runs.
**Action:** Always wrap profile images in `Semantics` and provide `tooltip` to `IconButton`. Use `FlutterError.onError` to ignore network errors in widget tests. Implement search clear buttons as `suffixIcon` with conditional visibility.

## 2024-05-24 - [Video Player Feedback and Consistent Tooltips]
**Learning:** Adding the  and  properties to a  widget provides immediate, discrete feedback during user interaction, which is especially helpful for volume and brightness controls. Dynamic tooltips that reflect the current state (e.g., Play vs. Pause) enhance clarity for all users, including those using screen readers.
**Action:** Always include  and  in  widgets for better feedback. Ensure all  widgets have descriptive  properties, and use dynamic tooltips for state-toggling buttons.

## 2024-05-24 - [Video Player Feedback and Consistent Tooltips]
**Learning:** Adding the `label` and `divisions` properties to a `Slider` widget provides immediate, discrete feedback during user interaction, which is especially helpful for volume and brightness controls. Dynamic tooltips that reflect the current state (e.g., Play vs. Pause) enhance clarity for all users, including those using screen readers.
**Action:** Always include `label` and `divisions` in `Slider` widgets for better feedback. Ensure all `IconButton` widgets have descriptive `tooltip` properties, and use dynamic tooltips for state-toggling buttons.
