import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Screen size
  final double screenWidth;
  final double screenHeight;
  final bool isTablet;

  ResponsiveHelper(BuildContext context)
    : screenWidth = MediaQuery.of(context).size.width,
      screenHeight = MediaQuery.of(context).size.height,
      isTablet = MediaQuery.of(context).size.width > 600;

  // Width as percentage of screen
  double wp(double percent) => screenWidth * percent / 375;

  // Height as percentage of screen
  double hp(double percent) => screenHeight * percent / 812;

  // Font size (scale for tablet)
  double fontSize(double size) => isTablet ? size * 1.5 : size;

  // Padding helpers
  EdgeInsets paddingAll(double percent) => EdgeInsets.all(wp(percent));

  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: wp(horizontal), vertical: hp(vertical));

  /// General border radius (scaled from width)
  double radius(double value) => wp(value);

  /// Circular radius (same scaling for height/width)
  double circle(double value) => wp(value);

  /// BorderRadius using responsive size
  BorderRadius borderRadius(double value) => BorderRadius.circular(wp(value));

  /// Different custom corners responsively
  BorderRadius borderRadiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(wp(topLeft)),
      topRight: Radius.circular(wp(topRight)),
      bottomLeft: Radius.circular(wp(bottomLeft)),
      bottomRight: Radius.circular(wp(bottomRight)),
    );
  }
}
