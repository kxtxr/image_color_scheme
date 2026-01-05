/// A Flutter package for dynamically extracting ColorSchemes from images.
///
/// This library provides widgets and utilities to create adaptive UIs that
/// respond to imagery using Material Design's dynamic color system.
///
/// ## Usage
///
/// ```dart
/// import 'package:image_color_scheme/image_color_scheme.dart';
///
/// // Using a network image URL:
/// ImageColorSchemeBuilder(
///   imageUrl: 'https://example.com/avatar.png',
///   builder: (context, colorScheme) {
///     return YourWidget(colorScheme: colorScheme);
///   },
/// )
///
/// // Using any ImageProvider:
/// ImageColorSchemeBuilder.fromProvider(
///   provider: MemoryImage(bytes),
///   builder: (context, colorScheme) {
///     return YourWidget(colorScheme: colorScheme);
///   },
/// )
///
/// // Direct computation:
/// final colorScheme = await computeColorSchemeFromImageProvider(
///   NetworkImage('https://example.com/image.png'),
///   Brightness.dark,
/// );
/// ```
library;

export 'src/image_color_scheme_builder.dart' show ImageColorSchemeBuilder;
export 'src/compute.dart' show computeColorSchemeFromImageProvider;
