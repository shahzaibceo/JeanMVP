import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/selection_header.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

Widget buildReminderSwitch(
  HabitCubit habitCubit,
  ThemeCubit themeCubit,
  ResponsiveHelper resp,
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SectionHeader(
        label: "reminder".tr(),
        textColor: themeCubit.textColor,
      ),

      Switch(
        value: habitCubit.state.isReminderOn,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.primary,
        inactiveThumbColor: AppColors.white,
        inactiveTrackColor: const Color(0xFF9199AA),

        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return Colors.transparent;
        }),

        onChanged: (val) => habitCubit.toggleReminder(val),
      ),
    ],
  );
}
