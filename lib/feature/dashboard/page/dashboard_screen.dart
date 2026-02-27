import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              _buildHeader(context, themeCubit),
              40.sbh(context),
              _buildFocusScoreSection(context, resp, themeCubit),
              40.sbh(context),
              _buildStartFocusButton(context, resp),
              40.sbh(context),
              _buildGettingStartedCard(context, resp, themeCubit),
              20.sbh(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeCubit themeCubit) {
    final now = DateTime.now();
    final dayFormat = DateFormat('EEEE, MMM d').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "TODAY",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: themeCubit.unselectedColor.withOpacity(0.6),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
        4.sbh(context),
        CustomText(
          text: dayFormat,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: themeCubit.textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildFocusScoreSection(BuildContext context, ResponsiveHelper resp, ThemeCubit themeCubit) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: resp.hp(250),
            width: resp.hp(250),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, Color(0xFF9F85FF)],
                    ).createShader(rect);
                  },
                  child: SizedBox(
                    height: resp.hp(230),
                    width: resp.hp(230),
                    child: CircularProgressIndicator(
                      value: 0.1, // Small starting indicator or 0
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor: themeCubit.greyColor.withOpacity(0.1),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "0",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: themeCubit.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: resp.hp(80),
                          ),
                    ),
                    CustomText(
                      text: "FOCUS SCORE",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: themeCubit.unselectedColor.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                    ),
                    4.sbh(context),
                    CustomText(
                      text: "Ready to start",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          24.sbh(context),
          CustomText(
            text: "\"Focus is the art of saying no.\"",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeCubit.unselectedColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartFocusButton(BuildContext context, ResponsiveHelper resp) {
    return CustomButton(
      text: "Start Focus",
      onTap: () {
        // Handle Start Focus
      },
      width: double.infinity,
      height: resp.hp(56),
      borderRadius: resp.radius(16),
      suffixIcon:  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
  );
  }

  Widget _buildGettingStartedCard(BuildContext context, ResponsiveHelper resp, ThemeCubit themeCubit) {
    return CustomContainer(
      width: double.infinity,
      padding: EdgeInsets.all(resp.wp(20)),
      borderRadius: resp.radius(24),
      color: themeCubit.containerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: resp.hp(48),
                width: resp.hp(48),
                borderRadius: resp.radius(12),
                color: AppColors.primary.withOpacity(0.1),
                child: const Center(
                  child: Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
                ),
              ),
              16.sbw(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Getting Started",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: themeCubit.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    8.sbh(context),
                    CustomText(
                      text: "Welcome to Focus. Let's reclaim your time. Track habits, set limits, and reach your peak potential.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeCubit.unselectedColor,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          24.sbh(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "SETUP PROGRESS",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: themeCubit.textColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
              CustomText(
                text: "1/3",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: themeCubit.textColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          8.sbh(context),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.33,
              backgroundColor: themeCubit.greyColor.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

}