import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

/// Horizontal nine-dot step indicator used across the urge-log flow.
///
/// The current step is rendered as a filled purple pill containing the
/// step number; past and future steps are minimal grey circles. Each
/// dot carries a short translated label below it (Rate, Trigger, …).
/// Render-only — no business logic.
class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final ThemeCubit themeCubit;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.themeCubit,
  });

  /// Labels for each of the nine steps, in order. Kept here (rather than
  /// in the cubit) because labels are purely a presentation concern.
  static const List<String> _labelKeys = [
    'step_rate',
    'step_trigger',
    'step_feelings',
    'step_notes',
    'step_back_to_you',
    'step_action',
    'step_intervention',
    'step_breathing',
    'step_immediate',
  ];

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    return Column(
      children: [
        Row(
          children: List.generate(_labelKeys.length * 2 - 1, (i) {
            // Even indices → dots, odd indices → connecting lines.
            if (i.isOdd) {
              return Expanded(
                child: Container(
                  height: 1,
                  color: themeCubit.unselectedColor.withValues(alpha: 0.25),
                ),
              );
            }
            final step = (i ~/ 2) + 1;
            return _StepDot(
              step: step,
              isCurrent: step == currentStep,
              themeCubit: themeCubit,
              resp: resp,
            );
          }),
        ),
        // 6.sbh(context),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: List.generate(_labelKeys.length, (i) {
        //     final isCurrent = (i + 1) == currentStep;
        //     return SizedBox(
        //       width: resp.wp(3),
        //       child: CustomText(
        //         textAlign: TextAlign.center,
        //         text: _labelKeys[i].tr(),
        //         maxLines: 1,
        //         overflow: true,
        //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //               fontSize: resp.fontSize(8),
        //               fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
        //               color: isCurrent
        //                   ? themeCubit.textColor
        //                   : themeCubit.unselectedColor.withValues(alpha: 0.7),
        //             ),
        //       ),
        //     );
        //   }),
        // ),
      ],
    );
  }
}

/// One numbered dot in the indicator.
class _StepDot extends StatelessWidget {
  final int step;
  final bool isCurrent;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const _StepDot({
    required this.step,
    required this.isCurrent,
    required this.themeCubit,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return CustomContainer(
        width: resp.wp(22),
        height: resp.wp(22),
        shape: BoxShape.circle,
        color: AppColors.primary,
        alignment: Alignment.center,
        child: CustomText(
          text: '$step',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white,
                fontSize: resp.fontSize(10),
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    }
    return CustomContainer(
      width: resp.wp(18),
      height: resp.wp(18),
      shape: BoxShape.circle,
      color: themeCubit.containerColor,
      border: Border.all(
        color: themeCubit.unselectedColor.withValues(alpha: 0.35),
        width: 1,
      ),
      alignment: Alignment.center,
      child: CustomText(
        text: '$step',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: themeCubit.unselectedColor,
              fontSize: resp.fontSize(9),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
