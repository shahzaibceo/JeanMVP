import 'package:flutter/material.dart';

extension GestureExtensions on Widget {
  /// Wraps this widget with GestureDetector for `onTap`
  Widget onTap(
    VoidCallback onTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(behavior: behavior, onTap: onTap, child: this);
  }

  /// Wraps this widget with GestureDetector for `onDoubleTap`
  Widget onDoubleTap(
    VoidCallback onDoubleTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(
      behavior: behavior,
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }

  /// Wraps this widget with GestureDetector for `onLongPress`
  Widget onLongPress(
    VoidCallback onLongPress, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(
      behavior: behavior,
      onLongPress: onLongPress,
      child: this,
    );
  }
}
