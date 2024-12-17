import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/route_observer.dart';

mixin RefreshOnPopMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  bool _isSubscribed = false;

  Future<void> refresh();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (!_isSubscribed) {
      final route = ModalRoute.of(context);
      if (route != null) {
        routeObserver.subscribe(this, route);
        _isSubscribed = true;
      }
    }
  }

  void _unsubscribe() {
    if (_isSubscribed) {
      routeObserver.unsubscribe(this);
      _isSubscribed = false;
    }
  }

  @override
  void didPopNext() {
    if (mounted) {
      refresh();
    }
  }
}
