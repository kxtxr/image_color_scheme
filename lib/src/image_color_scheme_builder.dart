import 'package:flutter/material.dart';

import 'compute.dart';

/// A widget that dynamically extracts a [ColorScheme] from an image and
/// rebuilds when the color scheme is ready.
///
/// This widget is useful for creating adaptive UIs that respond to imagery,
/// such as user avatars, album art, or other dynamic content.
///
/// The builder is called initially with the default [ColorScheme] from the
/// current theme, then called again once the color extraction completes.
///
/// Example:
/// ```dart
/// ImageColorSchemeBuilder(
///   provider: NetworkImage('https://example.com/avatar.png'),
///   builder: (context, colorScheme) {
///     return Scaffold(
///       backgroundColor: colorScheme.surface,
///       body: Container(
///         decoration: BoxDecoration(
///           gradient: LinearGradient(
///             colors: [colorScheme.primary, colorScheme.secondary],
///           ),
///         ),
///       ),
///     );
///   },
/// )
/// ```
class ImageColorSchemeBuilder extends StatefulWidget {
  /// The image provider to extract colors from.
  ///
  /// This accepts any [ImageProvider], including [NetworkImage], [MemoryImage],
  /// [AssetImage], [FileImage], etc.
  final ImageProvider<Object> provider;

  /// The builder function that receives the extracted [ColorScheme].
  ///
  /// This is called with the default theme color scheme initially, then
  /// again once color extraction completes.
  final Widget Function(BuildContext, ColorScheme) builder;

  /// Creates an [ImageColorSchemeBuilder] that extracts colors from an
  /// [ImageProvider].
  ///
  /// The [provider] accepts any [ImageProvider], including [NetworkImage],
  /// [MemoryImage], [AssetImage], [FileImage], etc.
  ///
  /// Example:
  /// ```dart
  /// ImageColorSchemeBuilder(
  ///   provider: NetworkImage('https://example.com/avatar.png'),
  ///   builder: (context, colorScheme) => YourWidget(),
  /// )
  /// ```
  const ImageColorSchemeBuilder({
    super.key,
    required this.provider,
    required this.builder,
  });

  @override
  State<ImageColorSchemeBuilder> createState() =>
      _ImageColorSchemeBuilderState();
}

class _ImageColorSchemeBuilderState extends State<ImageColorSchemeBuilder> {
  final ValueNotifier<ColorScheme?> _colorScheme = ValueNotifier(null);
  ImageProvider<Object>? _currentProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _colorScheme.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ImageColorSchemeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider) {
      _currentProvider = null;
      _colorScheme.value = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentProvider != widget.provider) {
      _currentProvider = widget.provider;
      _computeColorScheme();
    }
  }

  void _computeColorScheme() {
    computeColorSchemeFromImageProvider(
      widget.provider,
      Theme.of(context).brightness,
    ).then((colorScheme) {
      if (mounted) {
        _colorScheme.value = colorScheme;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<ColorScheme?>(
      valueListenable: _colorScheme,
      builder: (context, colorScheme, child) {
        return widget.builder(context, colorScheme ?? defaultColorScheme);
      },
    );
  }
}
