
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? textSize;
  final Color? borderColor;
  final Widget? suffixIcon;

  const CustomButton({
    super.key,
    this.suffixIcon,
    required this.onTap,
    required this.text,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.fontWeight,
    this.textSize,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final buttonColor = color ?? AppColors.primary;
    final buttonTextColor = textColor ?? AppColors.containerWhite;
    // final buttonTextSize = textSize ?? responsive.fontSize(18);

    return CustomContainer(
      width: width ?? double.infinity,
      height: height ?? responsive.hp(6),
      alignment: Alignment.center,

      borderRadius:borderRadius ?? responsive.radius(20),
      color: buttonColor,
      border: Border.all(
        color: borderColor ?? AppColors.primary,
        width: responsive.wp(0.3),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: fontWeight ?? FontWeight.w500,
              color: buttonTextColor,
              fontSize: textSize?? responsive.fontSize(20),
            ),
          ),
          if (suffixIcon != null) ...[
            responsive.wp(14).sbw(context),
            suffixIcon!,
          ],
        ],
      ),
    ).onTap(onTap ?? () {});
  }
}
