import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common_widget/custom_button.dart';
import '../../../common/common_widget/custom_conrtainer.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import '../../habit_creation/cubit/habit_cubit.dart';
import '../../habit_creation/page/habit_detail_screen.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final int index;
  final ResponsiveHelper resp;

  const HabitCard({
    super.key,
    required this.habit,
    required this.index,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>();

    final bool isDone = habit.timerElapsedPercent >= 1.0;
    final bool isNew = habit.timerElapsedPercent == 0.0;
    final bool isRunning = habit.timerIsRunning;

    String statusText = "new".tr();
    Color statusColor = AppColors.primary.withOpacity(.1);
    Color statusTextColor = AppColors.primary;

    if (isDone) {
      statusText = "done".tr();
      statusColor = Colors.green.withOpacity(.1);
      statusTextColor = Colors.green;
    } else if (isRunning) {
      statusText = "running".tr();
      statusColor = Colors.orange.withOpacity(.1);
      statusTextColor = Colors.orange;
    } else if (!isNew) {
      statusText = "paused".tr();
      statusColor = theme.greyColor.withOpacity(.1);
      statusTextColor = theme.unselectedColor;
    }

    return CustomContainer(
      margin: EdgeInsets.only(bottom: resp.hp(16)),
      padding: EdgeInsets.all(resp.wp(16)),
      borderRadius: resp.radius(24),
      color: theme.containerColor,
         border: Border.all(color: theme.greyColor, width: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: habit.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              CustomContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: resp.wp(22), vertical: resp.hp(4)),
                borderRadius: resp.radius(12),
                color: statusColor,
                   border: Border.all(color: theme.greyColor, width: 0.1),
                child: CustomText(
                  text: statusText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),

          4.sbh(context),

          /// STREAK
          Row(
            children: [
              Icon(Icons.local_fire_department,
                  color: isNew ? Colors.grey : Colors.green,
                  size: resp.wp(18)),
              4.sbw(context),
              CustomText(
                text: isNew ? "new_start".tr() : "${habit.streak} ${"day_streak".tr()}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isNew ? theme.unselectedColor : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          16.sbh(context),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: resp.hp(48),
                  borderRadius: resp.radius(12),
                  textSize: resp.fontSize(16),
                  text: isDone
                      ? "view_details".tr()
                      : (isRunning ? "pause".tr() : (isNew ? "start".tr() : "resume".tr())),
                  onTap: () => _handleAction(context, isDone, isRunning),
                ),
              ),
              12.sbw(context),
              Expanded(
                child: CustomButton(
                  borderColor:  theme.greyColor,
                  height: resp.hp(48),
                  textSize: resp.fontSize(16),
                  borderRadius: resp.radius(12),
                  text: "skipped".tr(),
                  color: isDone
                      ? theme.greyColor.withOpacity(.05)
                      : theme.greyColor.withOpacity(.1),
                  textColor: isDone
                      ? theme.greyColor.withOpacity(.5)
                      : theme.unselectedColor,
                  onTap: isDone ? null : () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- ACTION HANDLER ----------
  void _handleAction(BuildContext context, bool isDone, bool isRunning) {
    final cubit = context.read<HabitCubit>();

    if (isDone) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HabitDetailsScreen(habitIndex: index),
        ),
      );
      return;
    }

    if (isRunning) {
      cubit.pauseTimer(index);
      return;
    }

    final parts = habit.timerDuration.split(':');

    cubit.startTimer(
      index,
      Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
      ),
    );
  }
}