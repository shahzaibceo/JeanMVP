
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
import 'package:attention_anchor/feature/habit_creation/widget/habit_detail_widget/dialog_box_widget.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart'; 
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HabitDetailsScreen extends StatefulWidget {
  final int habitIndex;
  const HabitDetailsScreen({super.key, required this.habitIndex});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App went to background - auto-pause timer
      context.read<HabitCubit>().autoPauseTimer();
    }
  }

  Duration _parseDuration(String s) {
    final parts = s.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return Duration(hours: h, minutes: m);
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }


  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final habitCubit = context.watch<HabitCubit>(); 
    final resp = ResponsiveHelper(context);
    
    // Get habit directly from index - always in sync with cubit state
    if (widget.habitIndex < 0 || widget.habitIndex >= habitCubit.state.habits.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Habit not found')),
      );
    }
    
    final habit = habitCubit.state.habits[widget.habitIndex];
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitCreationView(
                    habitToEdit: habit,
                    index: widget.habitIndex,
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
                    value: habit.timerElapsedPercent,
                    strokeWidth: 8,
                    color: AppColors.primary,
                    backgroundColor: themeCubit.greyColor.withOpacity(0.3),
                  ),
                ),
                CustomText(
                  text: habit.timerIsRunning
                      ? "${(habit.timerElapsedPercent * 100).toStringAsFixed(0)}%"
                      : (habit.timerElapsedPercent > 0 ? "resume".tr() : "start".tr()),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: themeCubit.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ).onTap((){
                    if (habit.timerIsRunning) {
                      habitCubit.pauseTimer(widget.habitIndex);
                    } else {
                      habitCubit.startTimer(widget.habitIndex, totalDuration);
                    }
                  
            }),
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
                8.sbh(context),
                Row(
                  children: [
                    const Icon(Icons.timer, color: AppColors.primary, size: 18),
                    4.sbw(context),
                    CustomText(
                      text: habit.timerDuration,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: themeCubit.textColor,
                        fontWeight: FontWeight.w500,
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
                  text: "${"starts_from".tr()} ${_formatDate(habit.createdAt)}", 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: themeCubit.unselectedColor),
                ),
                20.sbh(context),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        borderRadius: resp.radius(12),
                        onTap: () {
                          if (habit.timerIsRunning) {
                            habitCubit.pauseTimer(widget.habitIndex);
                          } else {
                            habitCubit.startTimer(widget.habitIndex, totalDuration);
                          }
                        },
                        text: habit.timerIsRunning ? "pause".tr() : (habit.timerElapsedPercent > 0 ? "resume".tr() : "start".tr()),
                        height: resp.hp(50),
                      ),
                    ),
                    12.sbw(context),
                    Expanded(
                      child: CustomButton(
                        borderRadius: resp.radius(12),
                        onTap: () => showDeleteDialog(
                            context,widget.habitIndex ),
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