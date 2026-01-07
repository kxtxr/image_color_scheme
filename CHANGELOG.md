## 1.0.5

* Updated SDK constraint to `^3.4.3` for broader compatibility

## 1.0.4

* **Fixed:** Color scheme now updates correctly when image provider changes multiple times
  - Previously, changing the provider would only trigger a recomputation on the first change
  - `didUpdateWidget` now properly triggers `_computeColorScheme()` when provider changes

## 1.0.3

* **Breaking:** Builder signature now requires 3 parameters: `(context, colorScheme, child)`
* Added `onError` callback for handling color extraction failures
* Added `contrastLevel` parameter for adjusting color scheme contrast
* Added `dynamicSchemeVariant` parameter for Material Design scheme variants
* Added `ImageColorSchemeWidgetBuilder` typedef export
* Fixed race condition when provider changes during computation
* Widget now re-computes when `contrastLevel` or `dynamicSchemeVariant` changes
* Improved documentation with complete API reference

## 1.0.2

* Initial release
* `ImageColorSchemeBuilder` widget for extracting ColorScheme from images
* Support for any `ImageProvider` via constructor
* `computeColorSchemeFromImageProvider` helper function
* Automatic theme brightness detection
* Proper lifecycle management and cleanup
