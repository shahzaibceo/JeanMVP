import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final Color textColor;

  const SectionHeader({
    super.key,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
      final resp = ResponsiveHelper(context);
    return CustomText(
      text: label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: resp.fontSize(16),
                  ),
    ).withAllPadding(16);
  }
}