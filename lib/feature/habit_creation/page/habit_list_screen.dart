import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit%20_state.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_creation_screen.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_detail_screen.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final resp = ResponsiveHelper(context);

    return MainBackground(
      appBar: AppBarWidget(
        showBack: true,
        title: "habits".tr(),
      
      ),
      child: Stack(
        children: [
          BlocBuilder<HabitCubit, HabitState>(
            builder: (context, state) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  resp.wp(15),
                  resp.hp(12),
                  resp.wp(15),
                  resp.hp(100),
                ),
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  return CustomContainer(
                    margin: EdgeInsets.only(bottom: resp.hp(16)),
                    padding: EdgeInsets.symmetric(
                      horizontal: resp.wp(20),
                      vertical: resp.hp(12),
                    ),
                    border: Border.all(color: themeCubit.greyColor, width: 0.1),
                    borderRadius: resp.radius(20),
                    color: themeCubit.containerColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: habit.name,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: themeCubit.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            CustomContainer(
                              height: resp.hp(42),
                              width: resp.wp(42),
                              borderRadius: resp.radius(10),
                              color: AppColors.primary.withOpacity(0.1),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.icon,
                                  width: resp.wp(22),
                                  height: resp.hp(22),
                                  colorFilter: ColorFilter.mode(
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
                            const Icon(
                              Icons.timer,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            4.sbw(context),

                            CustomText(
                              text: habit.timerDuration,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: themeCubit.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.streakIcon,
                              color: habit.streak > 0
                                  ? Colors.green
                                  : (habit.lastCompletedDate == null
                                        ? Colors.grey
                                        : Colors.red),
                              height: resp.hp(16),
                              width: resp.wp(16),
                            ),
                            4.sbw(context),
                            CustomText(
                              text: habit.streak > 0
                                  ? "${habit.streak} ${"day_streak".tr()}"
                                  : (habit.lastCompletedDate == null
                                        ? "0 ${"day_streak".tr()}"
                                        : "end_streak".tr()),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: habit.streak > 0
                                        ? Colors.green
                                        : (habit.lastCompletedDate == null
                                              ? Colors.grey
                                              : Colors.red),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).onTap(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HabitDetailsScreen(habitIndex: index),
                      ),
                    );
                  });
                },
              );
            },
          ),
          Positioned(
            bottom: resp.hp(40),
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                width: resp.wp(300),
                suffixIcon: const Icon(
                  Icons.add_circle,
                  color: AppColors.white,
                  size: 22,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitCreationView(),
                    ),
                  );
                },
                text: "add_new".tr(),
                height: resp.hp(56),
                borderRadius: resp.radius(12),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
