import 'package:flutter/material.dart';

/// Computes a [ColorScheme] from an [ImageProvider].
///
/// This is a convenience function that wraps [ColorScheme.fromImageProvider]
/// with sensible defaults. Use this when you need to extract a color scheme
/// directly without using the widget.
///
/// The [provider] is the image source to extract colors from.
/// The [brightness] determines whether to generate a light or dark scheme.
///
/// Optional parameters:
/// - [contrastLevel]: Adjusts contrast (0.0 to 1.0). Defaults to 1.0.
/// - [dynamicSchemeVariant]: The Material Design scheme variant.
///   Defaults to [DynamicSchemeVariant.tonalSpot].
///
/// Returns a [Future] that completes with the extracted [ColorScheme].
///
/// Example:
/// ```dart
/// final provider = NetworkImage('https://example.com/image.png');
/// final colorScheme = await computeColorSchemeFromImageProvider(
///   provider,
///   Brightness.dark,
/// );
/// print('Primary: ${colorScheme.primary}');
/// ```
Future<ColorScheme> computeColorSchemeFromImageProvider(
  ImageProvider<Object> provider,
  Brightness brightness, {
  double contrastLevel = 1.0,
  DynamicSchemeVariant dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
}) {
  return ColorScheme.fromImageProvider(
    brightness: brightness,
    provider: provider,
    contrastLevel: contrastLevel,
    dynamicSchemeVariant: dynamicSchemeVariant,
  );
}
