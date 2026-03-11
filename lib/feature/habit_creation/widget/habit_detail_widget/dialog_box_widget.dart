import 'package:attention_anchor/common/common_widget/dialog_box/dialog_box_widget.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void showDeleteDialog(BuildContext context, int habitIndex) {
  final themeCubit = context.read<ThemeCubit>();
  final habitCubit = context.read<HabitCubit>();

  showDialog(
    context: context,
    builder: (dialogContext) => CustomConfirmationDialog(
      themeCubit: themeCubit,
      title: "delete_habit".tr(),
      message: "delete_habit_confirm".tr(),
      confirmText: "yes_delete".tr(),
      cancelText: "cancel".tr(),
      onConfirm: () {
        // 1. Close the Dialog
        Navigator.pop(dialogContext);
        
        // 2. Close the Detail Screen
        Navigator.pop(context);

        // 3. Switch to Dashboard tab
        context.read<BottomBarCubit>().changeTab(0);

        // 4. Delete the habit
        habitCubit.deleteHabit(habitIndex);
      },
    ),
  );
}

void showSkipDialog(BuildContext context, int habitIndex) {
  final themeCubit = context.read<ThemeCubit>();
  final habitCubit = context.read<HabitCubit>();

  showDialog(
    context: context,
    builder: (context) => CustomConfirmationDialog(
      themeCubit: themeCubit,
      title: "skip_habit".tr(),
      message: "skip_habit_confirm".tr(),
      confirmText: "yes_skip".tr(),
      cancelText: "cancel".tr(),
      onConfirm: () {
        habitCubit.skipHabit(habitIndex);
      },
    ),
  );
}