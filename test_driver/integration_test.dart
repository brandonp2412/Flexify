import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async => await integrationDriver(
      onScreenshot: (name, image, [args]) async {
        final imgFile =
            await File('screenshots/$name.png').create(recursive: true);
        await imgFile.writeAsBytes(image);
        return true;
      },
      writeResponseOnFailure: true,
    );
