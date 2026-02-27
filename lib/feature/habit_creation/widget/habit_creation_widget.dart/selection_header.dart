import 'package:attention_anchor/common/extensions/padding_extension.dart';
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
    return CustomText(
      text: label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
    ).withBottomPadding(16);
  }
}