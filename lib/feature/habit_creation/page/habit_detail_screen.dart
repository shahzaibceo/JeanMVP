
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_creation_screen.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart'; 
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';


class HabitDetailsScreen extends StatelessWidget {
  final HabitModel habit;
  const HabitDetailsScreen({super.key, required this.habit});

  Duration _parseDuration(String s) {
    final parts = s.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return Duration(hours: h, minutes: m);
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final habitCubit = context.watch<HabitCubit>(); 
    final resp = ResponsiveHelper(context);
    final totalDuration = _parseDuration(habit.timerDuration);

    return MainBackground(
      appBar: AppBarWidget(
        showBack: true,
        title: "habits".tr(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: resp.wp(16)),
            child: Center(
              child: CustomText(
                text: "edit".tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ).onTap(() {
              int habitIndex = context.read<HabitCubit>().state.habits.indexOf(habit);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitCreationView(
                    habitToEdit: habit,
                    index: habitIndex,
                  ),
                ),
              );
            }),
          )
        ],
      ),
      child: Column(
        children: [
          40.sbh(context),

          SizedBox(
            height: resp.hp(200),
            width: resp.hp(200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: resp.hp(210),
                  width: resp.hp(210),
                  child: CircularProgressIndicator(
                    value: habitCubit.state.elapsedPercent,
                    strokeWidth: 8,
                    color: AppColors.primary,
                    backgroundColor: themeCubit.greyColor.withOpacity(0.3),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (habitCubit.state.isRunning) {
                      habitCubit.pauseTimer();
                    } else {
                      habitCubit.startTimer(totalDuration);
                    }
                  },
                  child: CustomText(
                    text: habitCubit.state.isRunning
                        ? "${(habitCubit.state.elapsedPercent * 100).toStringAsFixed(0)}%"
                        : (habitCubit.state.elapsedPercent > 0 ? "resume".tr() : "start".tr()),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: themeCubit.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),

          40.sbh(context),

          CustomContainer(
            width: double.infinity,
            padding: EdgeInsets.all(resp.wp(16)),
            borderRadius: resp.radius(20),
            border: Border.all(color: themeCubit.greyColor, width: 0.1),
            color: themeCubit.containerColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: habit.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: themeCubit.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    CustomContainer(
                      height: resp.hp(40),
                      width: resp.hp(40),
                      border: Border.all(color: themeCubit.greyColor, width: 0.1),
                      borderRadius: resp.radius(10),
                      color: AppColors.primary.withOpacity(0.1),
                      child: Center(
                        child: SvgPicture.asset(
                          AppIcons.icon,
                          width: resp.wp(20),
                          height: resp.hp(20),
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                4.sbh(context),
                 Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.green, size: 18),
                    4.sbw(context),
                    CustomText(
                      text: "${habit.streak} ${"day_streak".tr()}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                20.sbh(context),
                CustomText(
                  text: "history".tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: themeCubit.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                5.sbh(context),

                  CustomText(
                  text: "${"starts_from".tr()} 16 Feb, 2026", 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: themeCubit.unselectedColor),
                ),
                20.sbh(context),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        borderRadius: resp.radius(12),
                        onTap: () {
                          if (habitCubit.state.isRunning) {
                            habitCubit.pauseTimer();
                          } else {
                            habitCubit.startTimer(totalDuration);
                          }
                        },
                        text: habitCubit.state.isRunning ? "pause".tr() : "resume".tr(),
                        height: resp.hp(50),
                      ),
                    ),
                    12.sbw(context),
                    Expanded(
                      child: CustomButton(
                        borderRadius: resp.radius(12),
                        onTap: () {
                          final index = context.read<HabitCubit>().state.habits.indexOf(habit);
                          context.read<HabitCubit>().deleteHabit(index);
                          Navigator.pop(context);
                        },
                        text: "delete".tr(),
                        color: themeCubit.greyColor,
                        textColor: themeCubit.textColor,
                        borderColor: Colors.transparent,
                        height: resp.hp(50),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ).withSymmetricPadding(horizontal: resp.wp(16)),
        ],
      ),
    );
  }
}