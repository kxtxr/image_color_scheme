import 'package:flutter/material.dart';

import 'compute.dart';

/// Signature for the builder function used by [ImageColorSchemeBuilder].
///
/// The [context] is the build context.
/// The [colorScheme] is the extracted color scheme, or the default theme
/// color scheme if extraction is still in progress or failed.
/// The [child] is the optional child widget passed to the builder.
typedef ImageColorSchemeWidgetBuilder =
    Widget Function(
      BuildContext context,
      ColorScheme colorScheme,
      Widget? child,
    );

/// A widget that dynamically extracts a [ColorScheme] from an image and
/// rebuilds when the color scheme is ready.
///
/// This widget is useful for creating adaptive UIs that respond to imagery,
/// such as user avatars, album art, or other dynamic content.
///
/// The builder is called initially with the default [ColorScheme] from the
/// current theme, then called again once the color extraction completes.
///
/// {@tool snippet}
/// Basic usage with a network image:
///
/// ```dart
/// ImageColorSchemeBuilder(
///   provider: NetworkImage('https://example.com/avatar.png'),
///   builder: (context, colorScheme, child) {
///     return Scaffold(
///       backgroundColor: colorScheme.surface,
///       body: Container(
///         decoration: BoxDecoration(
///           gradient: LinearGradient(
///             colors: [colorScheme.primary, colorScheme.secondary],
///           ),
///         ),
///         child: child,
///       ),
///     );
///   },
///   child: const Text('Hello'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [computeColorSchemeFromImageProvider], which is the underlying function
///    used to extract colors.
///  * [ColorScheme.fromImageProvider], the Flutter API this widget wraps.
class ImageColorSchemeBuilder extends StatefulWidget {
  /// Creates an [ImageColorSchemeBuilder] that extracts colors from an
  /// [ImageProvider].
  ///
  /// The [provider] parameter accepts any [ImageProvider], including
  /// [NetworkImage], [MemoryImage], [AssetImage], [FileImage], etc.
  ///
  /// The [builder] is called with the extracted [ColorScheme] once available,
  /// or with the default theme color scheme while loading or on error.
  ///
  /// The optional [child] parameter is passed through to the [builder] and
  /// can be used to optimize rebuilds by keeping static parts of the widget
  /// tree constant.
  const ImageColorSchemeBuilder({
    super.key,
    required this.provider,
    required this.builder,
    this.child,
    this.contrastLevel = 1.0,
    this.dynamicSchemeVariant = DynamicSchemeVariant.tonalSpot,
    this.onError,
  });

  /// The image provider to extract colors from.
  ///
  /// This accepts any [ImageProvider], including [NetworkImage], [MemoryImage],
  /// [AssetImage], [FileImage], etc.
  final ImageProvider provider;

  /// The builder function that receives the extracted [ColorScheme].
  ///
  /// This is called with the default theme color scheme initially, then
  /// again once color extraction completes successfully.
  ///
  /// The builder receives three arguments:
  /// - [BuildContext]: The build context
  /// - [ColorScheme]: The extracted color scheme (or default if loading/error)
  /// - [Widget?]: The optional [child] widget
  final ImageColorSchemeWidgetBuilder builder;

  /// An optional child widget to pass to the [builder].
  ///
  /// This is useful for optimizing rebuilds. Widgets that don't depend on
  /// the [ColorScheme] can be passed here to avoid unnecessary rebuilds.
  final Widget? child;

  /// The contrast level for the generated color scheme.
  ///
  /// Values range from 0.0 (minimum contrast) to 1.0 (maximum contrast).
  /// Defaults to 1.0.
  final double contrastLevel;

  /// The Material Design dynamic scheme variant to use.
  ///
  /// Defaults to [DynamicSchemeVariant.tonalSpot].
  final DynamicSchemeVariant dynamicSchemeVariant;

  /// Optional callback invoked when color extraction fails.
  ///
  /// If provided, this callback is called with the error and stack trace
  /// when [ColorScheme.fromImageProvider] throws an exception.
  ///
  /// When an error occurs, the [builder] is still called with the default
  /// theme color scheme.
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  State<ImageColorSchemeBuilder> createState() =>
      _ImageColorSchemeBuilderState();
}

class _ImageColorSchemeBuilderState extends State<ImageColorSchemeBuilder> {
  final ValueNotifier<ColorScheme?> _colorScheme = ValueNotifier(null);
  ImageProvider? _currentProvider;

  /// Tracks the current computation to handle race conditions.
  /// Incremented each time a new computation starts.
  int _computationId = 0;

  @override
  void dispose() {
    _colorScheme.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ImageColorSchemeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider ||
        oldWidget.contrastLevel != widget.contrastLevel ||
        oldWidget.dynamicSchemeVariant != widget.dynamicSchemeVariant) {
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

  Future<void> _computeColorScheme() async {
    final computationId = ++_computationId;

    try {
      final colorScheme = await computeColorSchemeFromImageProvider(
        widget.provider,
        Theme.of(context).brightness,
        contrastLevel: widget.contrastLevel,
        dynamicSchemeVariant: widget.dynamicSchemeVariant,
      );

      // Only update if this is still the current computation and widget is
      // still mounted. This prevents race conditions when the provider changes
      // while a computation is in progress.
      if (mounted && computationId == _computationId) {
        _colorScheme.value = colorScheme;
      }
    } catch (error, stackTrace) {
      if (mounted && computationId == _computationId) {
        widget.onError?.call(error, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<ColorScheme?>(
      valueListenable: _colorScheme,
      builder: (context, colorScheme, child) =>
          widget.builder(context, colorScheme ?? defaultColorScheme, child),

      child: widget.child,
    );
  }
}
