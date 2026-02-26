
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
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

class AboutUs extends StatelessWidget {
  AboutUs({super.key});


  @override
  Widget build(BuildContext context) {
       final themeCubit = context.watch<ThemeCubit>();
    final resp = ResponsiveHelper(context);
    FirebaseAnalytics.instance.logScreenView(screenName: "about_us");
    return MainBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarWidget(
          title: "about_hd_wallpaper".tr(),
          showBack: true,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            50.sbh(context),
            Image.asset(
              AppImages.gym,
              width: resp.wp(150),
              height: resp.hp(150),
              fit: BoxFit.contain,
            ),

            60.sbh(context),
            CustomText(
              text: "unleash_creativity".tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            5.sbh(context),
            CustomText(
              text: "app_description".tr() ,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: themeCubit.textColor,
              ),
            ).withAllPadding(20),
        
          ],
        ),
      ),
    ),
  );
}
}