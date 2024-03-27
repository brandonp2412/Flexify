import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async => await integrationDriver(
      onScreenshot: (name, image, [args]) async {
        final deviceType = Platform.environment["FLEXIFY_DEVICE_TYPE"];
        if (deviceType == null || deviceType.isEmpty) throw "FLEXIFY_DEVICE_TYPE must be set, so integration driver knows where to save screenshots.";
        final imgFile =
            await File('android/fastlane/metadata/android/en-US/images/$deviceType/$name.png').create(recursive: true);
        await imgFile.writeAsBytes(image);
        return true;
      },
      writeResponseOnFailure: true,
    );
