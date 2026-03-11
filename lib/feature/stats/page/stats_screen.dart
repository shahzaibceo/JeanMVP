
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit%20_state.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/stats/stats_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();

    return MainBackground(
      appBar: AppBarWidget(
        showBack: true,
        title: "stats".tr(),
      ),
      child: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          final habits = state.habits;

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/NO_stat.json',
                    width: resp.wp(300),
                    height: resp.hp(300),
                  ),
                  20.sbh(context),
                  SizedBox(
                    width: resp.wp(320),
                    child: CustomText(
                        textAlign: TextAlign.center,
                        text: "no_data_stat".tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: themeCubit.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                  ),
                
                ],
              ),
            );
          }

          final weeklyStats = StatsHelper.getWeeklyStats(habits);
          final monthlyAvg = StatsHelper.getMonthlyAvg(habits);
          final bestStreakHabit = StatsHelper.getBestStreakHabit(habits);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: resp.wp(20), vertical: resp.hp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
         
                    CustomText(
                      text: "weekly_stats".tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: themeCubit.textColor.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                   
                20.sbh(context),

                /// MAIN STATS CARD (Bar Chart)
                CustomContainer(
                  padding: EdgeInsets.all(resp.wp(20)),
                  borderRadius: resp.radius(24),
                  color: themeCubit.containerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "${(weeklyStats.values.reduce((a, b) => a + b) / 7 * 100).toInt()}%",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: themeCubit.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              CustomText(
                                text: "completion_rate_7d".tr(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: themeCubit.textColor.withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              8.sbw(context),
                              CustomText(
                                text: "active_goal".tr(),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      30.sbh(context),
                      SizedBox(
                        height: resp.hp(150),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: weeklyStats.entries.map((e) {
                            return _buildBar(context, e.key, e.value, resp, themeCubit);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                24.sbh(context),

                /// TWO CARDS ROW
                Row(
                  children: [
                    Expanded(
                      child: CustomContainer(
                        height: resp.hp(200),
                        padding: EdgeInsets.all(resp.wp(16)),
                        borderRadius: resp.radius(24),
                        color: themeCubit.containerColor,
                        child: Column(
                          children: [
                            CustomText(
                              text: "monthly_avg".tr(),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: themeCubit.textColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            20.sbh(context),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: resp.wp(80),
                                    height: resp.wp(80),
                                    child: CircularProgressIndicator(
                                      value: monthlyAvg,
                                      strokeWidth: 8,
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  CustomText(
                                    text: "${(monthlyAvg * 100).toInt()}%",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: themeCubit.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            10.sbh(context),
                            CustomText(
                              text: "monthly_completion".tr(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeCubit.textColor.withOpacity(0.5),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.sbw(context),
                    Expanded(
                      child: CustomContainer(
                        height: resp.hp(200),
                        padding: EdgeInsets.all(resp.wp(16)),
                        borderRadius: resp.radius(24),
                        color: themeCubit.containerColor,
                        child: Column(
                          children: [
                            CustomText(
                              text: "best_streak_title".tr(),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: themeCubit.textColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            20.sbh(context),
                            CustomContainer(
                              padding: EdgeInsets.all(resp.wp(12)),
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.1),
                              child: Icon(Icons.emoji_events, color: AppColors.primary, size: resp.wp(30)),
                            ),
                            10.sbh(context),
                            CustomText(
                              text: "${bestStreakHabit?.streak ?? 0} Days",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: themeCubit.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            5.sbh(context),
                            CustomText(
                              text: "personal_record".tr(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeCubit.textColor.withOpacity(0.5),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                24.sbh(context),

                
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context, String day, double percent, ResponsiveHelper resp, ThemeCubit theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: resp.wp(35),
          height: resp.hp(120) * (percent == 0 ? 0.05 : percent),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(resp.wp(8)),
          ),
        ),
        10.sbh(context),
        CustomText(
          text: day,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: theme.textColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
