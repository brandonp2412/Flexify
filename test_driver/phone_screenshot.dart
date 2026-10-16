import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Remove the unused Android status-bar inset, retaining AppBar top spacing.
Uint8List trimPhoneStatusBar(List<int> bytes) {
  final image = img.decodePng(Uint8List.fromList(bytes));
  if (image == null) throw const FormatException('Invalid screenshot PNG');

  final background = image.getPixel(0, 0);
  final topPadding = (image.width * 0.055).round();
  final scanLimit = (image.width * 0.22).round().clamp(0, image.height);
  var firstContentRow = 0;
  for (; firstContentRow < scanLimit; firstContentRow++) {
    var empty = true;
    for (var x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, firstContentRow);
      if (pixel.r != background.r ||
          pixel.g != background.g ||
          pixel.b != background.b ||
          pixel.a != background.a) {
        empty = false;
        break;
      }
    }
    if (!empty) break;
  }

  final cropTop = (firstContentRow - topPadding).clamp(
    0,
    (image.width * 0.14).round(),
  );
  final rgb = image.convert(numChannels: 3);
  return Uint8List.fromList(
    img.encodePng(
      cropTop == 0
          ? rgb
          : img.copyCrop(
              rgb,
              x: 0,
              y: cropTop,
              width: image.width,
              height: image.height - cropTop,
            ),
    ),
  );
}

/// Google Play requires 24-bit PNG screenshots without an alpha channel.
Uint8List toRgbPng(List<int> bytes) {
  final image = img.decodePng(Uint8List.fromList(bytes));
  if (image == null) throw const FormatException('Invalid screenshot PNG');
  return Uint8List.fromList(img.encodePng(image.convert(numChannels: 3)));
}
