# API Reference

## Classes

### ImageColorSchemeBuilder

A widget that dynamically extracts a `ColorScheme` from an image and rebuilds when the color scheme is ready.

#### Constructor

##### ImageColorSchemeBuilder()

Creates an `ImageColorSchemeBuilder` that extracts colors from an `ImageProvider`.

**Parameters:**
- `provider` (ImageProvider, required): Image source (e.g., NetworkImage, MemoryImage, AssetImage)
- `builder` (Widget Function(BuildContext, ColorScheme), required): Widget builder function

**Example:**
```dart
ImageColorSchemeBuilder(
  provider: NetworkImage('https://example.com/avatar.png'),
  builder: (context, colorScheme) {
    return Container(color: colorScheme.primary);
  },
)
```

#### Properties

- `provider` (ImageProvider): The image provider to extract colors from
- `builder` (Widget Function(BuildContext, ColorScheme)): The builder function

#### Behavior

1. Initially calls builder with the default theme color scheme
2. Loads the image from the provided `ImageProvider`
3. Extracts colors using Material Design's dynamic color algorithm
4. Calls builder again with the extracted color scheme
5. Rebuilds when the image changes
6. Respects theme brightness changes

## Functions

### computeColorSchemeFromImageProvider()

Computes a `ColorScheme` from an `ImageProvider` directly.

**Signature:**
```dart
Future<ColorScheme> computeColorSchemeFromImageProvider(
  ImageProvider<Object> provider,
  Brightness brightness, {
  double contrastLevel = 1.0,
  DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
})
```

**Parameters:**
- `provider` (ImageProvider, required): Image source
- `brightness` (Brightness, required): Light or dark theme
- `contrastLevel` (double, optional): Contrast adjustment (0.0 to 1.0). Defaults to 1.0
- `dynamicSchemeVariant` (DynamicSchemeVariant, optional): Material scheme variant. Defaults to `DynamicSchemeVariant.tonalSpot`

**Returns:** `Future<ColorScheme>`

**Example:**
```dart
final provider = NetworkImage('https://example.com/image.png');
final colorScheme = await computeColorSchemeFromImageProvider(
  provider,
  Brightness.dark,
  contrastLevel: 0.8,
  dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
);
```

## Color Scheme Properties

The extracted `ColorScheme` includes all Material Design 3 colors:

**Primary colors:**
- `primary`, `onPrimary`
- `primaryContainer`, `onPrimaryContainer`
- `primaryFixed`, `primaryFixedDim`
- `onPrimaryFixed`, `onPrimaryFixedVariant`

**Secondary colors:**
- `secondary`, `onSecondary`
- `secondaryContainer`, `onSecondaryContainer`
- `secondaryFixed`, `secondaryFixedDim`
- `onSecondaryFixed`, `onSecondaryFixedVariant`

**Tertiary colors:**
- `tertiary`, `onTertiary`
- `tertiaryContainer`, `onTertiaryContainer`
- `tertiaryFixed`, `tertiaryFixedDim`
- `onTertiaryFixed`, `onTertiaryFixedVariant`

**Error colors:**
- `error`, `onError`
- `errorContainer`, `onErrorContainer`

**Surface colors:**
- `surface`, `onSurface`
- `surfaceDim`, `surfaceBright`
- `surfaceContainerLowest`, `surfaceContainerLow`
- `surfaceContainer`, `surfaceContainerHigh`, `surfaceContainerHighest`
- `onSurfaceVariant`

**Other:**
- `outline`, `outlineVariant`
- `shadow`, `scrim`
- `inverseSurface`, `onInverseSurface`, `inversePrimary`

## Dynamic Scheme Variants

Available variants for `dynamicSchemeVariant`:

- `DynamicSchemeVariant.tonalSpot` (default): Balanced, harmonious colors
- `DynamicSchemeVariant.fidelity`: Stays closer to source image colors
- `DynamicSchemeVariant.content`: Optimized for content-focused UIs
- `DynamicSchemeVariant.monochrome`: Grayscale-based scheme
- `DynamicSchemeVariant.neutral`: Neutral, less saturated
- `DynamicSchemeVariant.vibrant`: More saturated, energetic
- `DynamicSchemeVariant.expressive`: Bold, expressive colors
- `DynamicSchemeVariant.rainbow`: Multi-hue rainbow effect
- `DynamicSchemeVariant.fruitSalad`: Playful, varied colors

## Best Practices

1. **Always provide fallback**: The builder receives the theme's default color scheme initially
2. **Use with Theme**: Wrap in `Theme` widget to provide default colors
3. **Handle loading states**: The widget rebuilds when colors are ready
4. **Optimize images**: Smaller images extract faster
5. **Cache images**: Consider using a caching `ImageProvider` for network images if needed
6. **Test brightness modes**: Verify both light and dark themes
7. **Accessibility**: Consider contrast levels for readability

## Migration from Material 2

If migrating from Material 2 `ColorScheme`, note:

- M3 has many more colors (60+ vs 13)
- Surface variants replace elevation-based surfaces
- `background` and `onBackground` are deprecated (use `surface` and `onSurface`)
- Fixed colors provide consistent tones regardless of brightness

## Performance Considerations

- Color extraction is async and may take 100-500ms
- Images are cached by Flutter's image cache
- The widget disposes resources properly
- No memory leaks with proper lifecycle management
- Provide your own `ImageProvider` for full control over caching

## Troubleshooting

**Colors not updating:**
- Ensure the image URL/provider changes
- Check that the widget is mounted
- Verify image loads successfully

**Wrong brightness:**
- The widget uses `Theme.of(context).brightness`
- Ensure a `Theme` widget exists in the tree
- Use `MediaQuery.platformBrightnessOf(context)` for system brightness

**Slow extraction:**
- Use smaller images (400x400 is usually sufficient)
- Compress images before upload
- Consider extracting once and caching the result
