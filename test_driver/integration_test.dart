import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async => await integrationDriver(
      onScreenshot: (name, image, [args]) async {
        final deviceType = Platform.environment["FLEXIFY_DEVICE_TYPE"];
        if (deviceType == null || deviceType.isEmpty)
          throw "FLEXIFY_DEVICE_TYPE must be set, so integration driver knows where to save screenshots.";
        File imgFile;
        if (Platform.isAndroid)
          imgFile = await File(
            'fastlane/metadata/android/en-US/images/$deviceType/$name.png',
          ).create(recursive: true);
        else
          imgFile = await File(
            'fastlane/screenshots/$deviceType-$name.png',
          ).create(recursive: true);
        print("Writing ${imgFile.path}");
        await imgFile.writeAsBytes(image);
        return true;
      },
      writeResponseOnFailure: true,
    );
