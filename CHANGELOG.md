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
