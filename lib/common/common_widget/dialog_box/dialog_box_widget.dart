import 'package:flutter/material.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart'; // Aapka custom button
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmButtonColor;
  final ThemeCubit themeCubit;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.themeCubit,
    this.confirmText = "Yes, delete",
    this.cancelText = "Cancel",
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomContainer(
        padding: EdgeInsets.all(resp.wp(24)),
        borderRadius: resp.radius(24),
        color: themeCubit.containerColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            16.sbh(context),
            CustomText(
              text: message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.unselectedColor,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            24.sbh(context),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    borderRadius: resp.radius(12),
                    onTap: () {
                      onConfirm();
                      Navigator.pop(context); // Dialog close karega
                    },
                    text: confirmText,
                    color: confirmButtonColor, // Custom color for delete/logout
                    height: resp.hp(50),
                    textSize: resp.fontSize(14),
                  ),
                ),
                12.sbw(context),
                Expanded(
                  child: CustomButton(
                    borderRadius: resp.radius(12),
                    onTap: () => Navigator.pop(context),
                    text: cancelText,
                    color: themeCubit.greyColor,
                    textColor: themeCubit.textColor,
                    borderColor: Colors.transparent,
                    textSize: resp.fontSize(14),
                    height: resp.hp(50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}