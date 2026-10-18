import 'package:flutter/material.dart';

/// Reports whether a tab's nested Navigator has a page above its root.
class TabNavigationObserver extends NavigatorObserver {
  TabNavigationObserver(this.onNestedPageChanged);

  final ValueChanged<bool> onNestedPageChanged;
  final _routes = <Route<dynamic>>[];

  void _notify() {
    final nested = _routes.length > 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onNestedPageChanged(nested);
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.add(route);
    _notify();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notify();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index >= 0) {
      if (newRoute == null) {
        _routes.removeAt(index);
      } else {
        _routes[index] = newRoute;
      }
    }
    _notify();
  }
}
