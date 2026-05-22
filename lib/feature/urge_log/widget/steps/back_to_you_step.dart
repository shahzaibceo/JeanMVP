// import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
// import 'package:attention_anchor/common/common_widget/custom_text.dart';
// import 'package:attention_anchor/common/extensions/gesture_detector.dart';
// import 'package:attention_anchor/common/extensions/sized_box.dart';
// import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
// import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
// import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
// import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
// import 'package:attention_anchor/theme/app_colors.dart';
// import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Step 5 — "Back to You". Celebrates the user's pause, then asks them
// /// to re-rate the urge on a compact 1..10 pill row.
// class BackToYouStep extends StatelessWidget {
//   final ThemeCubit themeCubit;
//   const BackToYouStep({super.key, required this.themeCubit});

//   @override
//   Widget build(BuildContext context) {
//     final resp = ResponsiveHelper(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         24.sbh(context),
//         Center(
//           child: CustomContainer(
//             width: resp.wp(96),
//             height: resp.wp(96),
//             shape: BoxShape.circle,
//             color: const Color(0xFF22C55E).withValues(alpha: 0.15),
//             alignment: Alignment.center,
//             child: Icon(
//               Icons.check_circle,
//               color: const Color(0xFF22C55E),
//               size: resp.wp(64),
//             ),
//           ),
//         ),
//         20.sbh(context),
//         CustomText(
//           textAlign: TextAlign.center,
//           text: 'nice_work'.tr(),
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: const Color(0xFF22C55E),
//                 fontWeight: FontWeight.w700,
//               ),
//         ),
//         8.sbh(context),
//         CustomText(
//           textAlign: TextAlign.center,
//           text: 'self_care_msg'.tr(),
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 color: themeCubit.unselectedColor,
//                 height: 1.5,
//               ),
//         ),
//         28.sbh(context),
//         BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
//           buildWhen: (a, b) => a.urgeRatingAfter != b.urgeRatingAfter,
//           builder: (context, state) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: 'urge_reduced'.tr(),
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         color: themeCubit.textColor,
//                         fontWeight: FontWeight.w700,
//                       ),
//                 ),
//                 4.sbh(context),
//                 CustomText(
//                   text: 'rate_again'.tr(),
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         color: themeCubit.unselectedColor,
//                       ),
//                 ),
//                 14.sbh(context),
//                 _RatingPillsRow(
//                   selected: state.urgeRatingAfter,
//                   onChanged:
//                       context.read<UrgeFlowCubit>().setUrgeRatingAfter,
//                   themeCubit: themeCubit,
//                   resp: resp,
//                 ),
//                 24.sbh(context),
//                 CustomText(
//                   text: 'great_understand'.tr(),
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         color: themeCubit.textColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// /// Horizontal 1..10 selectable pill row. The current pick is rendered
// /// in the brand purple; others as muted outlined circles.
// class _RatingPillsRow extends StatelessWidget {
//   final int? selected;
//   final ValueChanged<int> onChanged;
//   final ThemeCubit themeCubit;
//   final ResponsiveHelper resp;

//   const _RatingPillsRow({
//     required this.selected,
//     required this.onChanged,
//     required this.themeCubit,
//     required this.resp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(10, (i) {
//         final value = i + 1;
//         final isSelected = value == selected;
//         return CustomContainer(
//           width: resp.wp(26),
//           height: resp.wp(26),
//           shape: BoxShape.circle,
//           color: isSelected ? AppColors.primary : themeCubit.containerColor,
//           border: Border.all(
//             color: isSelected
//                 ? AppColors.primary
//                 : themeCubit.unselectedColor.withValues(alpha: 0.4),
//             width: 1,
//           ),
//           alignment: Alignment.center,
//           child: CustomText(
//             text: '$value',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: isSelected ? AppColors.white : themeCubit.textColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//         ).onTap(() => onChanged(value));
//       }),
//     );
//   }
// }


import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 5 — "Back to You". Celebrates the user's pause, then asks them
/// to re-rate the urge on a compact 1..10 pill row wrapped in structured containers.
class BackToYouStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const BackToYouStep({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.sbh(context),
        
        // --- Top Celebration Section ---
        Center(
          child: CustomContainer(
            width: resp.wp(96),
            height: resp.wp(96),
            shape: BoxShape.circle,
            color: const Color(0xFF22C55E).withValues(alpha: 0.15),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_circle,
              color: const Color(0xFF22C55E),
              size: resp.wp(64),
            ),
          ),
        ),
        20.sbh(context),
        CustomText(
          textAlign: TextAlign.center,
          text: 'nice_work'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF22C55E),
                fontWeight: FontWeight.w700,
              ),
        ),
        8.sbh(context),
        CustomText(
          textAlign: TextAlign.center,
          text: 'self_care_msg'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: themeCubit.unselectedColor,
                height: 1.5,
              ),
        ),
        24.sbh(context),

        // --- Interactive Rating and Message Containers ---
        BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
          buildWhen: (a, b) => a.urgeRatingAfter != b.urgeRatingAfter,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Rating Card Container
                CustomContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius:16,
                  color: themeCubit.containerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'urge_reduced'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: themeCubit.textColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      4.sbh(context),
                      CustomText(
                        text: 'rate_again'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: themeCubit.unselectedColor,
                            ),
                      ),
                      16.sbh(context),
                      _RatingPillsRow(
                        selected: state.urgeRatingAfter,
                        onChanged: context.read<UrgeFlowCubit>().setUrgeRatingAfter,
                        themeCubit: themeCubit,
                        resp: resp,
                      ),
                    ],
                  ),
                ),
                16.sbh(context),

                // 2. Feedback Message Card Container
                CustomContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius:16,
                  color: themeCubit.containerColor,
                  child: CustomText(
                    text: 'great_understand'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: themeCubit.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Horizontal 1..10 selectable pill row. 
/// Selected index matches the green accent color from the image UI mockup.
class _RatingPillsRow extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onChanged;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const _RatingPillsRow({
    required this.selected,
    required this.onChanged,
    required this.themeCubit,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    // UI Mockup ke mutabiq rating fill color green (0xFF22C55E) hai
    const activeColor = Color(0xFF22C55E);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (i) {
        final value = i + 1;
        final isSelected = value == selected;
        
        return CustomContainer(
          width: resp.wp(26),
          height: resp.wp(26),
          shape: BoxShape.circle,
          color: isSelected ? activeColor : themeCubit.containerColor,
          border: Border.all(
            color: isSelected
                ? activeColor
                : themeCubit.unselectedColor.withValues(alpha: 0.2),
            width: 1,
          ),
          alignment: Alignment.center,
          child: CustomText(
            text: '$value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.white : themeCubit.textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ).onTap(() => onChanged(value));
      }),
    );
  }
}