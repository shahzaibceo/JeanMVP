

import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/build_weekly_days.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/name_field_widget.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/selection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_list_screen.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/build_remindeer_switch.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/build_time_box.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/build_time_input.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';

class HabitCreationView extends StatefulWidget {
  final HabitModel? habitToEdit;
  final int? index;

  const HabitCreationView({super.key, this.habitToEdit, this.index});

  @override
  State<HabitCreationView> createState() => _HabitCreationViewState();
}

class _HabitCreationViewState extends State<HabitCreationView> {
  late TextEditingController _nameController;
  late TextEditingController _timerHours;
  late TextEditingController _timerMints;
  late TextEditingController _fromHours;
  late TextEditingController _fromMints;

  final List<String> weekDays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.habitToEdit?.name ?? "");

    // Logic for splitting Reminder Time
    String timeStr = widget.habitToEdit?.time ?? "";
    if (timeStr.isNotEmpty) {
      final parts = timeStr.split(" ");
      final timeParts = parts[0].split(":");
      _fromHours = TextEditingController(text: timeParts[0]);
      _fromMints = TextEditingController(text: timeParts[1]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<HabitCubit>();
        cubit.updatePeriod(parts[1]);
        if (widget.habitToEdit != null) cubit.setInitialDays(widget.habitToEdit!.days);
      });
    } else {
      _fromHours = TextEditingController();
      _fromMints = TextEditingController();
    }

    // Logic for splitting Timer Duration
    String duration = widget.habitToEdit?.timerDuration ?? "";
    if (duration.isNotEmpty && duration.contains(":")) {
      final dParts = duration.split(":");
      _timerHours = TextEditingController(text: dParts[0]);
      _timerMints = TextEditingController(text: dParts[1]);
    } else {
      _timerHours = TextEditingController();
      _timerMints = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timerHours.dispose();
    _timerMints.dispose();
    _fromHours.dispose();
    _fromMints.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final habitCubit = context.watch<HabitCubit>();
    final resp = ResponsiveHelper(context);

    return MainBackground(
      appBar: AppBarWidget(showBack: true, title: "habit_creation".tr()),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: resp.wp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.sbh(context),
              SectionHeader(label: "habit_name".tr(), textColor: themeCubit.textColor,),
              HabitNameField(controller: _nameController, themeCubit: themeCubit, resp: resp),
              
              24.sbh(context),
              SectionHeader(label: "week_days".tr(), textColor: themeCubit.textColor, ),
              WeekDaysSelector(weekDays: weekDays, habitCubit: habitCubit, themeCubit: themeCubit, resp: resp),
              
              24.sbh(context),
              SectionHeader(label: "set_timer".tr(), textColor: themeCubit.textColor,),
              buildTimerBox(
                themeCubit: themeCubit,
                resp: resp,
                context: context,
                hController: _timerHours,
                mController: _timerMints,
              ),
              
              24.sbh(context),
              buildReminderSwitch(habitCubit, themeCubit, resp, context),
              
              if (habitCubit.state.isReminderOn) ...[
                16.sbh(context),
                buildTimeInputCard(context, themeCubit, resp, _fromHours, _fromMints, 
                    habitCubit.state.fromPeriod, (val) => habitCubit.updatePeriod(val)),
              ],
              
              40.sbh(context),
              _buildActionButton(resp, habitCubit),
              20.sbh(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(ResponsiveHelper resp, HabitCubit habitCubit) {
    bool isEdit = widget.habitToEdit != null;
    return CustomContainer(
      width: double.infinity,
      height: resp.hp(56),
      borderRadius: resp.radius(18),
      color: AppColors.primary,
      child: Center(
        child: CustomText(
          text: (isEdit ? "update" : "save").tr(),
          style:  Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600
                  ),
        ),
      ),
    ).onTap(() => _handleSave(habitCubit));
  }

  void _handleSave(HabitCubit habitCubit) {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please_enter_habit_name".tr())));
      return;
    }

    String timerDur = "${_timerHours.text.isEmpty ? "00" : _timerHours.text}:${_timerMints.text.isEmpty ? "00" : _timerMints.text}";
    String reminderTime = "${_fromHours.text.isEmpty ? "00" : _fromHours.text}:${_fromMints.text.isEmpty ? "00" : _fromMints.text} ${habitCubit.state.fromPeriod}";

    if (widget.habitToEdit != null) {
      final updatedHabit = HabitModel(
        name: _nameController.text,
        days: habitCubit.state.selectedDays,
        time: reminderTime,
        timerDuration: timerDur,
        streak: widget.habitToEdit!.streak,
      );
      habitCubit.updateHabit(widget.index!, updatedHabit);
      Navigator.pop(context);
    } else {
      habitCubit.saveHabitAndSchedule(
        title: _nameController.text,
        h: _fromHours.text.isEmpty ? "0" : _fromHours.text,
        m: _fromMints.text.isEmpty ? "0" : _fromMints.text,
        period: habitCubit.state.fromPeriod,
        timerDuration: timerDur,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HabitsListScreen()));
    }
  }
}