import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit%20_state.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/history/widget/history_card.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
  final themeCubit = context.watch<ThemeCubit>();
    return MainBackground(
      appBar: AppBarWidget(
        showBack: true,
        title: "history".tr(),
      ),
      child: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          if (state.habits.isEmpty) {
            return Center(
              child: CustomText(text:"no_habits_yet".tr(),style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                     color: themeCubit.textColor,
                                     fontWeight: FontWeight.w500,
                                   ),),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              resp.wp(15), 
              resp.hp(12), 
              resp.wp(15), 
              resp.hp(100)
            ),
            itemCount: state.habits.length,
            itemBuilder: (context, index) {
              return HistoryCard(habit: state.habits[index]);
            },
          );
        },
      ),
    );
  }
}
