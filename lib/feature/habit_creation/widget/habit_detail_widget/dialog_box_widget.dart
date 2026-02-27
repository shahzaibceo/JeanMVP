import 'package:attention_anchor/common/common_widget/dialog_box/dialog_box_widget.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showDeleteDialog(BuildContext context,int habitIndex) {
  final themeCubit = context.read<ThemeCubit>();
  final habitCubit = context.read<HabitCubit>();

  showDialog(
    context: context,
    builder: (context) => CustomConfirmationDialog(
      themeCubit: themeCubit,
      title: "Delete Habit Focus",
      message: "Are you sure, you want to delete\nthis Habit focus activity?",
      confirmText: "Yes, delete",
      cancelText: "cancel".tr(),
      onConfirm: () {
        habitCubit.deleteHabit(habitIndex);
        Navigator.pop(context);
      },
    ),
  );
}