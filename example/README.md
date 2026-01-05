# image_color_scheme Examples

This example app demonstrates various use cases for the `image_color_scheme` package.

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

## Examples Included

### 1. Network Image
Demonstrates extracting colors from a network image URL using `ImageColorSchemeBuilder`. Shows how the derived color scheme can be used throughout the UI with gradients and Material components.

### 2. Memory Image
Shows how to use `ImageColorSchemeBuilder.fromProvider` with dynamically generated images. Includes a button to cycle through different colors and watch the color scheme update automatically.

### 3. Multiple Images
Demonstrates switching between different images and how the color scheme smoothly transitions when the image changes.

### 4. Profile Card
A realistic example showing how to build a profile page with dynamic colors derived from a user's avatar. Includes:
- Gradient backgrounds
- Dynamic app bar colors
- Themed cards and buttons
- Smooth color transitions

## Key Takeaways

- The widget falls back to the default theme color scheme while the image is loading
- Colors update automatically when the image changes
- Works seamlessly with Material Design 3 components
- Theme brightness is respected automatically
- Proper lifecycle management prevents memory leaks
