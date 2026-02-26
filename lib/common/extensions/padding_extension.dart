import 'package:flutter/widgets.dart';

extension PaddingExtension on Widget {
  /// Adds symmetric horizontal & vertical padding
  Widget withSymmetricPadding({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Adds only left padding
  Widget withLeftPadding(double value) {
    return Padding(
      padding: EdgeInsets.only(left: value),
      child: this,
    );
  }

  /// Adds only right padding
  Widget withRightPadding(double value) {
    return Padding(
      padding: EdgeInsets.only(right: value),
      child: this,
    );
  }

  /// Adds only top padding
  Widget withTopPadding(double value) {
    return Padding(
      padding: EdgeInsets.only(top: value),
      child: this,
    );
  }

  /// Adds only bottom padding
  Widget withBottomPadding(double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: value),
      child: this,
    );
  }

  /// Adds all side padding
  Widget withAllPadding(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  /// Adds custom EdgeInsets padding
  Widget withCustomPadding({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }
}
