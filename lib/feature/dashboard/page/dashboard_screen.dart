import 'package:attention_anchor/feature/dashboard/widget/focus_session_section.dart';
import 'package:attention_anchor/feature/dashboard/widget/foucs_score_widget.dart';
import 'package:attention_anchor/feature/dashboard/widget/getting_started_card.dart';
import 'package:attention_anchor/feature/dashboard/widget/header_widget.dart';
import 'package:attention_anchor/feature/dashboard/widget/start_foucs_button.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  String _title(int step) {
    switch (step) {
      case 1:
        return "getting_started_title".tr();
      case 2:
        return "define_goals_title".tr();
      case 3:
        return "stay_on_track_title".tr();
      default:
        return "";
    }
  }

  String _desc(int step) {
    switch (step) {
      case 1:
        return "welcome_focus_desc".tr();
      case 2:
        return "tell_us_improve_desc".tr();
      case 3:
        return "turn_on_reminders_desc".tr();
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final resp = ResponsiveHelper(context);

    return MainBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: resp.wp(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.sbh(context),
              HeaderSection(themeCubit: themeCubit),
              40.sbh(context),
              FocusScoreSection(resp: resp, themeCubit: themeCubit),
              40.sbh(context),
              BlocBuilder<HabitCubit, HabitState>(
                builder: (context, habitState) {
                  if (habitState.habits.isEmpty) {
                    return Column(
                      children: [
                        StartFocusButton(resp: resp),
                        40.sbh(context),
                        GettingStartedCard(
                          resp: resp,
                          themeCubit: themeCubit,
                          titleBuilder: _title,
                          descBuilder: _desc,
                        ),
                      ],
                    );
                  } else {
                    return FocusSessionsSection(resp: resp, state: habitState);
                  }
                },
              ),
              20.sbh(context),
            ],
          ),
        ),
      ),
    );
  }
}