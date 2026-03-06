
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/constants/image_strings/app_images.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final resp = ResponsiveHelper(context);
       final isDark = themeCubit.state.isDark;
    FirebaseAnalytics.instance.logScreenView(screenName: "about_us");
    return MainBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarWidget(
          title: "about_us_title".tr(),
          showBack: true,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                60.sbh(context),
                SvgPicture.asset(
                  isDark ? AppIcons.focusdark : AppIcons.focus,
                  width: resp.wp(240),
                  height: resp.hp(56),
                  fit: BoxFit.contain,
                ),
                47.sbh(context),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "welcome_to".tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: themeCubit.textColor,
                            ),
                      ),
                      TextSpan(
                        text: "focus_behavior".tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                47.sbh(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "published_by".tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: themeCubit.textColor.withOpacity(0.7),
                          ),
                    ),
                    05.sbw (context),
                   Image.asset(
                       AppImages.appIcon,
                        width: resp.wp(26),
                        height: resp.hp(26),
                      ),
                    
                    5.sbw(context),
                    CustomText(
                      text: "dev_name".tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: themeCubit.textColor,
                          ),
                    ),
                  ],
                ),
                20.sbh(context),
                CustomText(
                  text: "about_us_description".tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: themeCubit.textColor.withOpacity(0.8),
                        height: 1.5,
                      ),
                ).withSymmetricPadding(horizontal: resp.wp(24)),
                40.sbh(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
