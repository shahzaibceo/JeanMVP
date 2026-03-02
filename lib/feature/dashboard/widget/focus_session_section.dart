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
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HabitCreationView(),
                  ),
                );
              },
              child: Row(
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
              ),
            ),
          ],
        ),

        16.sbh(context),

        /// ---------- HABIT LIST ----------
        ...state.habits.asMap().entries.map((entry) {
          return HabitCard(
            habit: entry.value,
            index: entry.key,
            resp: resp,
          );
        }).toList(),
      ],
    );
  }
}