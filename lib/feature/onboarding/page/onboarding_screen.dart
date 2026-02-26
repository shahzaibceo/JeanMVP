import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/settings/pages/setting_page.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
   OnboardingScreen({super.key});

  final List<Map<String, String>> onboardingOptions = [
    {
      "title": "attention",
      "subtitle": "attention_desc",
      "icon": AppIcons.attention,
    },
    {
      "title": "discipline",
      "subtitle": "discipline_desc",
      "icon": AppIcons.descipline,
    },
    {
      "title": "intentional_living",
      "subtitle": "intentional_living_desc",
      "icon": AppIcons.intention,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: MainBackground(
      
      child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.sbh(context),
                  
                  CustomText(
                    text: "what_improve".tr(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: themeCubit.textColor,
                        ),
                  ).withSymmetricPadding(horizontal: resp.wp(20)),

                  12.sbh(context),

                  CustomText(
                    text: "choose_focus".tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textGrayForDark,
                          fontWeight: FontWeight.w500,
                        ),
                  ).withSymmetricPadding(horizontal: resp.wp(20)),

                  16.sbh(context),

                  BlocBuilder<OnboardingCubit, int>(
                    builder: (context, selectedIndex) {
                      return ListView.builder(
                        itemCount: onboardingOptions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: resp.wp(20)),
                        itemBuilder: (context, index) {
                          final option = onboardingOptions[index];
                          final isSelected = selectedIndex == index;

                          return CustomContainer(
                            width: resp.wp(335),
                            margin: EdgeInsets.only(bottom: resp.hp(16)),
                            padding: EdgeInsets.all(resp.wp(16)),
                            borderRadius: resp.radius(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 2,
                            ),
                            color: themeCubit.containerColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  height: resp.hp(50),
                                  width: resp.wp(50),
                                  borderRadius: resp.radius(10),
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.primary.withOpacity(0.1),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      option["icon"]!,
                                      width: resp.wp(22),
                                      height: resp.hp(22),
                                      colorFilter: ColorFilter.mode(
                                        isSelected ? Colors.white : AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                10.sbw(context),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: option["title"]!.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: themeCubit.textColor,
                                                ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              color: AppColors.primary,
                                              size: resp.wp(22),
                                            ),
                                        ],
                                      ),
                                      4.sbh(context),
                                      CustomText(
                                        text: option["subtitle"]!.tr(),
                                        maxLines: 4,
                                        overflow: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: AppColors.textGrayForDark,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).onTap(() {
                            context.read<OnboardingCubit>().selectOption(index);
                          });
                        },
                      );
                    },
                  ),

                  20.sbh(context),

                  // Button logic
                  Builder(
                    builder: (context) {
                      return CustomButton(
                        onTap: () {
                          final finalSelection = context.read<OnboardingCubit>().state;
                          print("Final selection: $finalSelection");
                                 Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>  SettingsScreen()),
      );
                          
                        },
                        text: "continue".tr(),
                        width: resp.wp(350),
                        height: resp.hp(60),
                        borderRadius: resp.radius
                        (16.0),
                        textSize: resp.fontSize(16),
                        fontWeight: FontWeight.w500,
                      ).withSymmetricPadding(horizontal: resp.wp(20));
                    }
                  ),
                  
                  40.sbh(context),
                ],
              ),
            ),
          ),
        ),
    );
  }
}