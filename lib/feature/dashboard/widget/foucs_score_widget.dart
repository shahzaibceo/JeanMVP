import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../feature/localization/translation/app_translation.dart';
import '../../habit_creation/cubit/habit_cubit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/cubit/theme_cubit.dart';

class FocusScoreSection extends StatelessWidget {
  final ResponsiveHelper resp;
  final ThemeCubit themeCubit;

  const FocusScoreSection({
    super.key,
    required this.resp,
    required this.themeCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, HabitState>(
      builder: (context, habitState) {
        final totalHabits = habitState.habits.length;
        final completedHabits =
            habitState.habits.where((h) => h.timerElapsedPercent >= 1.0).length;
        final progress =
            totalHabits > 0 ? completedHabits / totalHabits : 0.0;
        final displayScore = (progress * 100).toInt();

        return Center(
          child: Column(
            children: [
              SizedBox(
                height: resp.hp(200),
                width: resp.hp(200),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                        height: resp.hp(230),
                      width: resp.hp(230),
                      child: CircularProgressIndicator(
                        value: progress == 0.0 ? 0.01 : progress,
                        strokeWidth: 12,
                        strokeCap: StrokeCap.round,
                        backgroundColor:
                            themeCubit.greyColor.withOpacity(0.1),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: "$displayScore",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: themeCubit.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: resp.hp(80),
                              ),
                        ),
                        CustomText(
                          text: "focus_score".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: themeCubit.unselectedColor.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                        ),
                        4.sbh(context),
                        CustomText(
                          text: totalHabits == 0
                              ? "no_habits_yet".tr()
                              : (progress >= 1.0
                                  ? "all_habits_done".tr()
                                  : "$completedHabits / $totalHabits ${"habits_done_count".tr()}"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              24.sbh(context),
              CustomText(
                text: "focus_quote".tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: themeCubit.unselectedColor,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}