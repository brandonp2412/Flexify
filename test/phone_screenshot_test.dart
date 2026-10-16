import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import '../test_driver/phone_screenshot.dart';

void main() {
  test('trims only empty header rows and retains AppBar spacing', () {
    final screenshot = img.Image(width: 100, height: 200);
    img.fill(screenshot, color: img.ColorRgb8(21, 18, 24));
    img.fillRect(
      screenshot,
      x1: 10,
      y1: 16,
      x2: 89,
      y2: 46,
      color: img.ColorRgb8(120, 110, 120),
    );

    final cropped = trimPhoneStatusBar(img.encodePng(screenshot));
    final result = img.decodePng(cropped)!;
    expect(trimPhoneStatusBar(cropped), cropped);
    expect(result.width, 100);
    expect(result.height, 190); // Retains six pixels above the content.
    expect(result.getPixel(10, 6).r, 120);
  });

  test('does not crop content that already starts at the top', () {
    final screenshot = img.Image(width: 100, height: 200);
    img.fill(screenshot, color: img.ColorRgb8(21, 18, 24));
    screenshot.setPixelRgb(10, 0, 120, 110, 120);

    final input = img.encodePng(screenshot);
    expect(trimPhoneStatusBar(input), input);
  });
}
