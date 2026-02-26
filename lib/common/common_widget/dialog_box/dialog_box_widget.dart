import 'package:attention_anchor/common/common_widget/dialog_box/dialog_button.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onYesTap,
}) {
  final resp = ResponsiveHelper(context);
  final themeCubit = context.read<ThemeCubit>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: themeCubit.containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: themeCubit.textPrimaryColor,
              fontSize: resp.fontSize(20),
            ),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: themeCubit.textPrimaryColor,
            ),
      ),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: resp.wp(20),
        vertical: resp.hp(10),
      ),
      actions: [
        dialogButton(
          context,
          "No",
          themeCubit.textPrimaryColor,
          themeCubit.backgroundColor,
          () => Navigator.of(ctx).pop(),
        ),
        dialogButton(
          context,
          "Yes",
          themeCubit.backgroundColor,
          themeCubit.textPrimaryColor,
          onYesTap,
        ),
      ],
    ),
  );
}