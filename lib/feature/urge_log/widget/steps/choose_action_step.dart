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

/// Step 6 — "Choose Your Action". Two large tappable cards (Breathing
/// Exercise / Immediate Action) plus a "View more tools" affordance.
class ChooseActionStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const ChooseActionStep({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) => a.actionChosen != b.actionChosen,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.sbh(context),
            CustomText(
              text: 'choose_action_q'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            6.sbh(context),
            CustomText(
              text: 'pick_one'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.unselectedColor,
                  ),
            ),
            18.sbh(context),
            _ActionCard(
              icon: Icons.self_improvement,
              accent: AppColors.primary,
              tint: AppColors.primary.withValues(alpha: 0.10),
              titleKey: 'breathing_exercise',
              subtitleKey: 'breathing_subtitle',
              metaKey: 'breathing_duration',
              isSelected: state.actionChosen == UrgeAction.breathing,
              themeCubit: themeCubit,
              resp: resp,
              onTap: () => context
                  .read<UrgeFlowCubit>()
                  .selectAction(UrgeAction.breathing),
            ),
            14.sbh(context),
            _ActionCard(
              icon: Icons.bolt,
              accent: const Color(0xFF22C55E),
              tint: const Color(0xFF22C55E).withValues(alpha: 0.10),
              titleKey: 'immediate_action',
              subtitleKey: 'immediate_subtitle',
              metaKey: 'quick_start',
              isSelected: state.actionChosen == UrgeAction.immediate,
              themeCubit: themeCubit,
              resp: resp,
              onTap: () => context
                  .read<UrgeFlowCubit>()
                  .selectAction(UrgeAction.immediate),
            ),
            // 18.sbh(context),
            // Center(
            //   child: CustomText(
            //     text: 'view_more_tools'.tr(),
            //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //           color: AppColors.primary,
            //           fontWeight: FontWeight.w600,
            //           decoration: TextDecoration.underline,
            //         ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final Color tint;
  final String titleKey;
  final String subtitleKey;
  final String metaKey;
  final bool isSelected;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.accent,
    required this.tint,
    required this.titleKey,
    required this.subtitleKey,
    required this.metaKey,
    required this.isSelected,
    required this.themeCubit,
    required this.resp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(resp.wp(14)),
      borderRadius: resp.radius(18),
      color: tint,
      border: Border.all(
        color: isSelected ? accent : accent.withValues(alpha: 0.25),
        width: isSelected ? 1.6 : 1,
      ),
      child: Row(
        children: [
          CustomContainer(
            width: resp.wp(48),
            height: resp.wp(48),
            shape: BoxShape.circle,
            color: accent,
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.white, size: resp.fontSize(22)),
          ),
          14.sbw(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: titleKey.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                4.sbh(context),
                CustomText(
                  text: subtitleKey.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: themeCubit.textColor,
                        height: 1.4,
                      ),
                ),
                6.sbh(context),
                CustomText(
                  text: metaKey.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: themeCubit.unselectedColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).onTap(onTap);
  }
}
