import 'dart:async';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/feature/bottom_nav/page/bottomnav_page.dart';
import 'package:attention_anchor/feature/localization/page/localization_page.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _navigateToNext();
    });
  }

  void _navigateToNext() {
    final onboardingState = context.read<OnboardingCubit>().state;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _getTargetScreen(onboardingState.isCompleted),
      ),
    );
  }

  Widget _getTargetScreen(bool isCompleted) {
    if (isCompleted) {
      return const BottomNavigationBarScreen();
    } else {
      return const SelectLanguageScreen(showBackButton: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();
     final isDark = themeCubit.state.isDark;

    return MainBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const Spacer(),
            
            SvgPicture.asset(
                  isDark ? AppIcons.focusdark : AppIcons.focus,
                  width: resp.wp(240),
                  height: resp.hp(56),
                  fit: BoxFit.contain,
                ),
                
         
               200.sbh(context),
            Column(
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: resp.wp(100),
                  height: resp.wp(50),
                  child: const CupertinoActivityIndicator(
                    radius: 30, 
                     color: AppColors.primary, 
                  ),
                ),
                
           5.sbh(context),
                
                CustomText(
                  text: "loading".tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: themeCubit.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: resp.fontSize(16),
                      ),
                ),
                     60.sbh(context),
              ],
            ),
          ],
        ),
      ).withSymmetricPadding(vertical: resp.hp(5)),
    );
  }
}