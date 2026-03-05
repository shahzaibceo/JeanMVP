import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/feature/dashboard/widget/habit_card_widget.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_creation_screen.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/cubit/theme_cubit.dart';
import '../../dashboard/cubit/dashboard_view_cubit.dart';
import '../../habit_creation/cubit/habit_cubit.dart';

class FocusSessionsSection extends StatelessWidget {
  final ResponsiveHelper resp;
  final HabitState state;

  const FocusSessionsSection({
    super.key,
    required this.resp,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final dashboardViewState = context.watch<DashboardViewCubit>().state;
    final selectedDate = dashboardViewState.selectedDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------- HEADER ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "focus_sessions".tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            /// ADD BUTTON
            if (state.habits.where((h) => 
              context.read<HabitCubit>().isDaySelected(h, selectedDate)
            ).isNotEmpty)
              Row(
                children: [
                   Icon(
                    Icons.add_circle,
                    color: AppColors.primary,
                    size: resp.wp(20),
                  ),
                  4.sbw(context),
                  CustomText(
                    text: "add".tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ).onTap((){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitCreationView(),
                    ),
                  );
              }),
          ],
        ),

        16.sbh(context),

        /// ---------- HABIT LIST ----------
        if (state.habits.where((h) => 
          context.read<HabitCubit>().isDaySelected(h, selectedDate)
        ).isEmpty)
          CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: resp.wp(20),vertical: resp.hp(12)),
            borderRadius: resp.radius(24),
            color: themeCubit.containerColor,
            border: Border.all(color: themeCubit.greyColor, width: 0.1),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: resp.wp(40),
                ),
                12.sbh(context),
                CustomText(
                  text: "motivation_quote_title".tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: themeCubit.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                8.sbh(context),
                CustomText(
                  text: "motivation_quote_desc".tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: themeCubit.unselectedColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                16.sbh(context),
                CustomText(
                  text: "+ ${"add_new".tr()}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ).onTap(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitCreationView(),
                    ),
                  );
                }),
               
              ],
            ),
          )
        else
          ...state.habits.asMap().entries.where((entry) => 
            context.read<HabitCubit>().isDaySelected(entry.value, selectedDate)
          ).map((entry) {
            return HabitCard(
              habit: entry.value,
              index: entry.key,
              resp: resp,
            );
          }).toList(),
          20.sbh(context)
      ],
    );
  }
}