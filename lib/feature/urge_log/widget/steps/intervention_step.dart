import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/constants/image_strings/app_images.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_log_cubit.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterventionStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const InterventionStep({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) =>
          a.urgeRating != b.urgeRating ||
          a.urgeRatingAfter != b.urgeRatingAfter ||
          a.currentStep != b.currentStep,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.sbh(context),
            Center(
              child: CustomContainer(
                width: resp.wp(60),
                height: resp.wp(60),
                shape: BoxShape.circle,
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                alignment: Alignment.center,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFEF4444),
                  size: resp.wp(34),
                ),
              ),
            ),
            16.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'high_urge_detected'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            10.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'high_urge_detail'
                  .tr()
                  .replaceFirst('{rating}', (state.urgeRatingAfter ?? state.urgeRating).toString()),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.unselectedColor,
                    height: 1.5,
                  ),
            ),
            22.sbh(context),
            _BreathePromptCard(themeCubit: themeCubit, resp: resp),
            // 14.sbh(context),
            // CustomButton(
            //   text: 'start_breathing'.tr(),
            //   onTap: () {
            //     // Override any earlier "immediate" pick — the user is
            //     // electing breathing right now.
            //     context
            //         .read<UrgeFlowCubit>()
            //         .selectAction(UrgeAction.breathing);
            //     context.read<UrgeFlowCubit>().nextStep();
            //   },
            //   borderRadius: resp.radius(14),
            //   height: resp.hp(52),
            //   textSize: resp.fontSize(16),
            //   // suffixIcon: const Icon(Icons.play_arrow_rounded,
            //   //     color: AppColors.white, size: 20),
            // ),
            // 10.sbh(context),
            // Center(
            //   child: CustomText(
            //     text: 'skip_for_now'.tr(),
            //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //           color: AppColors.primary,
            //           fontWeight: FontWeight.w600,
            //         ),
            //   ).onTap(() {
            //     // Skip the breathing override; let nextStep route to
            //     // the step matching the user's step-6 selection.
            //     context.read<UrgeFlowCubit>().nextStep();
            //   }),
            // ),
            // 22.sbh(context),
            // _SupportCard(themeCubit: themeCubit, resp: resp),
          ],
        );
      },
    );
  }
}
/// Exact replica of the UI image design card.
class _BreathePromptCard extends StatelessWidget {
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const _BreathePromptCard({required this.themeCubit, required this.resp});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: resp.radius(24),
      color: themeCubit.containerColor,
      // Mild shadow effect matching the UI card elevation
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Mountain Illustration Banner
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(resp.radius(24)),
              topRight: Radius.circular(resp.radius(24)),
            ),
            child: SizedBox(
              height: resp.hp(140), 
              width: double.infinity,
              child: Image.asset(
                AppImages.frame, 
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. Content Section (Padding only inside this area)
          Padding(
            padding: EdgeInsets.all(resp.wp(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Duration (2 min) Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'take_deep_breath'.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF1E1A4A), // Dark navy tone from image
                              fontWeight: FontWeight.w800,
                              fontSize: resp.fontSize(18),
                            ),
                      ),
                    ),
                    // "2 min" Badge
                    CustomContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: resp.wp(12),
                        vertical: resp.hp(6),
                      ),
                      borderRadius: resp.radius(16),
                      color: const Color(0xFFEEF2FF), // Very soft lavender/blue tint
                      child: CustomText(
                        text: 'two_minutes'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF4338CA), // Deep indigo
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
                4.sbh(context),
                
                // Description subtitle text
                FractionallySizedBox(
                  widthFactor: 0.8, // To break lines gracefully like the mockup
                  child: CustomText(
                    text: 'calm_mind_msg'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                             color: themeCubit.unselectedColor,
                          height: 1.3,
                        ),
                  ),
                ),
                20.sbh(context),
                
                // 3. Action Buttons inside the card
                CustomButton(
                  text: 'start_breathing'.tr(),
                  onTap: () {
                    context.read<UrgeFlowCubit>().selectAction(UrgeAction.breathing);
                    context.read<UrgeFlowCubit>().nextStep();
                  },
                  borderRadius: resp.radius(16),
                  height: resp.hp(50),
                  textSize: resp.fontSize(16),
                  color: const Color(0xFF6366F1), 
                 
                ),
                16.sbh(context),
                
                // "Skip for now" trigger link
                Center(
                  child: CustomText(
                    text: 'immediate_action'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF4338CA),
                          fontWeight: FontWeight.w700,
                        ),
                  ).onTap(() {
                    context.read<UrgeFlowCubit>().selectAction(UrgeAction.immediate);
                    context.read<UrgeFlowCubit>().nextStep();
                  }),
                ),
                4.sbh(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class _SupportCard extends StatelessWidget {
//   final ThemeCubit themeCubit;
//   final ResponsiveHelper resp;
//   const _SupportCard({required this.themeCubit, required this.resp});

//   @override
//   Widget build(BuildContext context) {
//     return CustomContainer(
//       padding: EdgeInsets.all(resp.wp(14)),
//       borderRadius: resp.radius(16),
//       color: themeCubit.containerColor,
//       border: Border.all(
//         color: themeCubit.greyColor.withValues(alpha: 0.4),
//         width: 0.6,
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.support_agent_outlined,
//               color: AppColors.primary, size: resp.fontSize(22)),
//           12.sbw(context),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: 'need_immediate_support'.tr(),
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         color: themeCubit.textColor,
//                         fontWeight: FontWeight.w700,
//                       ),
//                 ),
//                 4.sbh(context),
//                 CustomText(
//                   text: 'support_subtitle'.tr(),
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: themeCubit.unselectedColor,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(Icons.chevron_right,
//               color: themeCubit.unselectedColor, size: resp.fontSize(20)),
//         ],
//       ),
//     );
//   }
// }
