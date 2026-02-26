import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

extension ResponsiveNum on num {
  /// Returns a SizedBox with responsive height
  SizedBox sbh(BuildContext context) =>
      SizedBox(height: ResponsiveHelper(context).hp(toDouble()));

  /// Returns a SizedBox with responsive width
  SizedBox sbw(BuildContext context) =>
      SizedBox(width: ResponsiveHelper(context).wp(toDouble()));

  /// Returns a responsive font size
  double font(BuildContext context) =>
      ResponsiveHelper(context).fontSize(toDouble());
}
