
import 'package:flutter/material.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';

class WeekDaysSelector extends StatelessWidget {
  final List<String> weekDays;
  final HabitCubit habitCubit;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const WeekDaysSelector({
    super.key,
    required this.weekDays,
    required this.habitCubit,
    required this.themeCubit,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: weekDays.map((day) {
          bool isSelected = habitCubit.state.selectedDays.contains(day);
          return CustomContainer(
            margin: EdgeInsets.only(right: resp.wp(10)),
            height: resp.hp(70),
            width: resp.wp(40),
            border: Border.all(color: themeCubit.greyColor, width: 0.1)  ,
            borderRadius: resp.radius(16),
            color: isSelected ? AppColors.primary : themeCubit.containerColor,
            child: Center(
              child: CustomText(
                text: day.tr(),
                style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:  isSelected ? AppColors.white : themeCubit.textColor,
                    fontWeight: FontWeight.w400,
                  ),
              ),
            ),
          ).onTap(() => habitCubit.toggleDay(day));
        }).toList(),
      ),
    );
  }
}