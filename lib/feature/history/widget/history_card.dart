import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HistoryCard extends StatelessWidget {
  final HabitModel habit;
  const HistoryCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final resp = ResponsiveHelper(context);

    final bool isEnded = habit.streak == 0 && habit.lastCompletedDate != null;
    final String statusText = isEnded ? "ended".tr() : "in_process".tr();
    final Color statusColor = isEnded ? Colors.red : Colors.green;

    String dateStr = "";
    if (habit.lastCompletedDate != null) {
        try {
            final date = DateTime.parse(habit.lastCompletedDate!);
            final months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
            dateStr = "${date.day}-${months[date.month - 1].tr()}-${date.year}";
        } catch (e) {
            dateStr = habit.lastCompletedDate!;
        }
    } else {
        final date = DateTime.fromMillisecondsSinceEpoch(habit.createdAt);
        final months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
        dateStr = "${date.day}-${months[date.month - 1].tr()}-${date.year}";
    }

    return CustomContainer(
      margin: EdgeInsets.only(bottom: resp.hp(16)),
      padding: EdgeInsets.symmetric(horizontal: resp.wp(20), vertical: resp.hp(16)),
      border: Border.all(color: themeCubit.greyColor.withOpacity(0.1), width: 1),
      borderRadius: resp.radius(20),
      color: themeCubit.containerColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: habit.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: themeCubit.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomText(
                text: statusText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          5.sbh(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.streakIcon,
                    color: isEnded ? Colors.red : Colors.green,
                    height: resp.hp(18),
                    width: resp.wp(18),
                  ),
                  4.sbw(context),
                  CustomText(
                    text: isEnded 
                        ? "end_streak".tr() 
                        : "${habit.streak} ${"day_streak".tr()}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isEnded ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              CustomText(
                text: dateStr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: themeCubit.textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
