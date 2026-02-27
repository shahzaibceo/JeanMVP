import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_detail_screen.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart'; // Localization import
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
                padding: EdgeInsets.all(resp.wp(16)),
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  return CustomContainer(
                    margin: EdgeInsets.only(bottom: resp.hp(16)),
                    padding: EdgeInsets.all(resp.wp(16)),
                     border: Border.all(color: themeCubit.greyColor, width: 0.1)  ,
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
                              style:Theme.of(context).textTheme.titleSmall?.copyWith(
                    color:   themeCubit.textColor,
                    fontWeight: FontWeight.w600
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
                            const Icon(Icons.local_fire_department,
                                color: Colors.green, size: 16),
                            4.sbw(context),
                            CustomText(
                              text: "${habit.streak} ${"day_streak".tr()}",
                              
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:   Colors.green,
                    fontWeight: FontWeight.w500
                  ),
                            ),
                          ],
                        ),
                        16.sbh(context),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                borderRadius: resp.radius(12),
                                onTap: () {},
                                text: "done".tr(), 
                                color: AppColors.primary,
                                textColor: Colors.white,
                                borderColor: Colors.transparent,
                                height: resp.hp(50),
                              ),
                            ),
                            12.sbw(context),
                            Expanded(
                              child: CustomButton(
                                borderRadius: resp.radius(12),
                                onTap: () {},
                                text: "skipped".tr(), 
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
                  ).onTap(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HabitDetailsScreen(habitIndex: index),
                      ),
                    );
                  });
                },
              );
            },
          ),
          Positioned(
            bottom: resp.hp(30),
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                width: resp.wp(300),
                suffixIcon: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 22,
                ),
                onTap: () {
                  Navigator.pop(context);
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