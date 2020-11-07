import 'package:flutter/material.dart';

class DoubleCallFilter<T> {
  T _lastValue;
  int _lastValueTime = 0;
  final int timeoutMs;
  final Future Function(T) action;

  DoubleCallFilter({@required this.action, this.timeoutMs = 3000});

  Future<dynamic> call(T value) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (_lastValue == value) {
      if (currentTime - _lastValueTime <= timeoutMs) {
        return;
      }
    }
    _lastValue = value;
    _lastValueTime = currentTime;
    if (action != null) await action(_lastValue);
  }
}
