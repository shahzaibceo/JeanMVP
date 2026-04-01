
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_images.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/feature/bottom_nav/page/bottomnav_page.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_state.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  final bool isFromSettings;
  OnboardingScreen({super.key, this.isFromSettings = false});
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "prefix": "onboarding_title_1_prefix",
      "color": "onboarding_title_1_color",
      "desc": "onboarding_desc_1",
      "image": AppImages.onboarding1,
    },
    {
      "prefix": "onboarding_title_2_prefix",
      "color": "onboarding_title_2_color",
      "desc": "onboarding_desc_2",
      "image": AppImages.onboarding2,
    },
    {
      "prefix": "onboarding_title_3_prefix",
      "color": "onboarding_title_3_color",
      "desc": "onboarding_desc_3",
      "image": AppImages.onboarding3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
     final themeCubit = context.watch<ThemeCubit>();

    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: MainBackground(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: resp.hp(550), 
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) => context.read<OnboardingCubit>().selectOption(index),
                    itemBuilder: (context, index) {
                      return Image.asset(
                        onboardingData[index]["image"]!,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                  if (state.selectedOption < onboardingData.length - 1)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + resp.hp(10),
                    right: resp.wp(5),
                    child: CustomButton(
                      onTap: () {
                        context.read<OnboardingCubit>().completeOnboarding();
                        context.read<BottomBarCubit>().changeTab(0);
                        
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
                          (route) => false,
                        );
                      },
                      text: "skip".tr(),
                      width: resp.wp(80),
                      height: resp.hp(35),
                      borderRadius: resp.radius(20),
                      color: Colors.black.withValues(alpha:  0.5), 
                      textColor: Colors.white,
                      textSize: resp.fontSize(12),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: resp.hp(300),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeCubit.backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    padding: EdgeInsets.all(resp.wp(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: themeCubit.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                            children: [
                              TextSpan(text: onboardingData[state.selectedOption]["prefix"]!.tr()),
                              TextSpan(
                                text: onboardingData[state.selectedOption]["color"]!.tr(),
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                              ),
                            ],
                          ),
                        ),
                        15.sbh(context),
                        
                        // Description
                        CustomText(
                          text: onboardingData[state.selectedOption]["desc"]!.tr(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: themeCubit.unselectedColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(
                                onboardingData.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 6),
                                  height: 6,
                                  width: state.selectedOption == index ? 24 : 8,
                                  decoration: BoxDecoration(
                                    color: state.selectedOption == index
                                        ? AppColors.primary
                                        : AppColors.primary.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            CustomButton(
                              onTap: () {
                                if (state.selectedOption < onboardingData.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  context.read<OnboardingCubit>().completeOnboarding();
                                  context.read<BottomBarCubit>().changeTab(0);
                                  if (isFromSettings) {
                                    Navigator.of(context).pop();
                                      _pageController.jumpToPage(0);
                                  } else {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
                                      (route) => false,
                                    );
                                  }
                                }
                              },
                              text: state.selectedOption < onboardingData.length - 1 
                                  ? "next".tr() 
                                  : "get_started".tr(), 
                              width: resp.wp(160),
                              height: resp.hp(55),
                              borderRadius: resp.radius(16.0),
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        20.sbh(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}