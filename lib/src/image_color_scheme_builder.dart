import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'compute.dart';

/// A widget that dynamically extracts a [ColorScheme] from an image and
/// rebuilds when the color scheme is ready.
///
/// This widget is useful for creating adaptive UIs that respond to imagery,
/// such as user avatars, album art, or other dynamic content.
///
/// The widget provides two constructors:
/// - [ImageColorSchemeBuilder] for network images via URL
/// - [ImageColorSchemeBuilder.fromProvider] for any [ImageProvider]
///
/// The builder is called initially with the default [ColorScheme] from the
/// current theme, then called again once the color extraction completes.
///
/// Example:
/// ```dart
/// ImageColorSchemeBuilder(
///   imageUrl: 'https://example.com/avatar.png',
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
  /// The network image URL to extract colors from.
  ///
  /// This is used with the default constructor and internally creates a
  /// [CachedNetworkImageProvider].
  final String? imageUrl;

  /// The image provider to extract colors from.
  ///
  /// This is used with the [fromProvider] constructor.
  final ImageProvider<Object>? imageProvider;

  /// The builder function that receives the extracted [ColorScheme].
  ///
  /// This is called with the default theme color scheme initially, then
  /// again once color extraction completes.
  final Widget Function(BuildContext, ColorScheme) builder;

  /// Creates an [ImageColorSchemeBuilder] that extracts colors from a
  /// network image URL.
  ///
  /// The [imageUrl] must be a valid network image URL.
  /// The [builder] is called with the current color scheme.
  const ImageColorSchemeBuilder({
    super.key,
    required String imageUrl,
    required this.builder,
  })  : imageUrl = imageUrl,
        imageProvider = null;

  /// Creates an [ImageColorSchemeBuilder] that extracts colors from an
  /// [ImageProvider].
  ///
  /// This constructor accepts any [ImageProvider], including [MemoryImage],
  /// [AssetImage], [FileImage], etc.
  ///
  /// Example:
  /// ```dart
  /// ImageColorSchemeBuilder.fromProvider(
  ///   provider: MemoryImage(bytes),
  ///   builder: (context, colorScheme) => YourWidget(),
  /// )
  /// ```
  const ImageColorSchemeBuilder.fromProvider({
    super.key,
    required ImageProvider<Object> provider,
    required this.builder,
  })  : imageProvider = provider,
        imageUrl = null;

  @override
  State<ImageColorSchemeBuilder> createState() => _ImageColorSchemeBuilderState();
}

class _ImageColorSchemeBuilderState extends State<ImageColorSchemeBuilder> {
  final ValueNotifier<ColorScheme?> _colorScheme = ValueNotifier(null);
  final ValueNotifier<ImageProvider<Object>?> _imageProvider = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _imageProvider.addListener(() {
      if (_imageProvider.value != null && mounted) {
        computeColorSchemeFromImageProvider(
          _imageProvider.value!,
          Theme.of(context).brightness,
        ).then((colorScheme) {
          if (mounted) {
            _colorScheme.value = colorScheme;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _imageProvider.dispose();
    _colorScheme.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ImageColorSchemeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final Object? oldKey = oldWidget.imageUrl ?? oldWidget.imageProvider;
    final Object? newKey = widget.imageUrl ?? widget.imageProvider;
    if (oldKey != newKey) {
      _imageProvider.value = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imageProvider.value == null) {
      if (widget.imageProvider != null) {
        _imageProvider.value = widget.imageProvider;
      } else if (widget.imageUrl != null) {
        _imageProvider.value = CachedNetworkImageProvider(widget.imageUrl!);
      }
    }
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