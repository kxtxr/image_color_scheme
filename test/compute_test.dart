import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_color_scheme/image_color_scheme.dart';

Future<Uint8List> _onePixelPng({ui.Color color = const ui.Color(0xFFFF0000)}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final paint = ui.Paint()..color = color;
  canvas.drawRect(ui.Rect.fromLTWH(0, 0, 1, 1), paint);
  final picture = recorder.endRecording();
  final image = await picture.toImage(1, 1);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('computeColorSchemeFromImageProvider returns a ColorScheme with requested brightness', () async {
    final bytes = await _onePixelPng();
    final provider = MemoryImage(bytes);

    final lightScheme = await computeColorSchemeFromImageProvider(
      provider,
      Brightness.light,
    );
    expect(lightScheme, isA<ColorScheme>());
    expect(lightScheme.brightness, Brightness.light);

    final darkScheme = await computeColorSchemeFromImageProvider(
      provider,
      Brightness.dark,
    );
    expect(darkScheme.brightness, Brightness.dark);
  });
}
