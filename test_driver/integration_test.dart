import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

import 'phone_screenshot.dart';

Future<void> main() async => await integrationDriver(
  onScreenshot: (name, image, [args]) async {
    final deviceType = Platform.environment["FLEX_DEVICE_TYPE"];
    if (deviceType == null || deviceType.isEmpty)
      throw "FLEX_DEVICE_TYPE must be set, so integration driver knows where to save screenshots.";
    final isWeb =
        deviceType == 'desktop' ||
        Platform.environment["FLUTTER_WEB"] == "true" ||
        args?.toString().contains("chrome") == true ||
        args?.toString().contains("web") == true ||
        Platform.environment["FLUTTER_DRIVER_DEVICE"] == "chrome" ||
        Platform.environment["FLUTTER_DRIVER_DEVICE"]?.contains("chrome") ==
            true;

    final storeLocale =
        RegExp(r'_([a-z]{2}(?:-[A-Z]{2})?)$').firstMatch(name)?.group(1) ??
        'en-US';

    File imgFile;
    if (isWeb) {
      imgFile = await File(
        'fastlane/screenshots/$deviceType-$name.png',
      ).create(recursive: true);
    } else {
      imgFile = await File(
        'fastlane/metadata/android/$storeLocale/images/$deviceType/$name.png',
      ).create(recursive: true);
    }
    await imgFile.writeAsBytes(
      !isWeb
          ? (deviceType == 'phoneScreenshots'
                ? trimPhoneStatusBar(image)
                : toRgbPng(image))
          : image,
    );
    stdout.writeln('Saved ${imgFile.path} (${image.length} bytes)');
    return true;
  },
  writeResponseOnFailure: true,
);
