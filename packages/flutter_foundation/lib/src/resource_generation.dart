import 'package:flutter/foundation.dart';

/// A generation counter that can be observed with ValueListenableBuilder.
class ResourceGeneration extends ValueNotifier<int> {
  ResourceGeneration() : super(0);

  /// Advances the generation and notifies listeners.
  void bump() {
    value = value + 1;
  }
}
