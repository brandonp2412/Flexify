import 'package:flutter/material.dart';

class MockTabController extends ChangeNotifier implements TabController {
  @override
  int get index => 0;

  @override
  set index(int value) {}

  @override
  int get previousIndex => 0;

  @override
  void animateTo(
    int value, {
    Duration? duration,
    Curve curve = Curves.ease,
  }) {}

  @override
  Animation<double> get animation => AlwaysStoppedAnimation(0.0);

  @override
  bool get hasListeners => super.hasListeners;

  @override
  int get length => 2;

  @override
  double get offset => 0.0;

  @override
  set offset(double value) {}

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  @override
  void reset() {}

  @override
  set indexIsChanging(bool value) {}

  @override
  bool get indexIsChanging => false;

  @override
  Duration get animationDuration => Duration.zero;
}
