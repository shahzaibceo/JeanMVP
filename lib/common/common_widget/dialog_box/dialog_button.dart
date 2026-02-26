import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

// 🔹 Dialog Button Builder
Widget dialogButton(
  BuildContext context,
  String text,
  Color bg,
  Color textColor,
  VoidCallback onTap,
) {
  final resp = ResponsiveHelper(context);
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: bg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: Size(resp.wp(100), resp.hp(45)),
    ),
    child: CustomText(
      text: text.toUpperCase(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}
