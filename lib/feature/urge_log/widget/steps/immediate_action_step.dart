import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_log_cubit.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 9 — "Immediate Action". Renders a list of small, achievable
/// actions the user can do right now to redirect attention. The
/// "Complete Log" button at the bottom persists the entry and dismisses
/// the flow.
class ImmediateActionStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const ImmediateActionStep({super.key, required this.themeCubit});

  static const List<_QuickAction> _actions = [
    _QuickAction('action_walk', Icons.directions_walk),
    _QuickAction('action_water', Icons.local_drink_outlined),
    _QuickAction('action_pushups', Icons.fitness_center),
    _QuickAction('action_song', Icons.music_note_outlined),
    _QuickAction('action_read', Icons.menu_book_outlined),
    _QuickAction('action_other', Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        20.sbh(context),
        Center(
          child: Icon(Icons.bolt,
              color: AppColors.primary, size: resp.fontSize(28)),
        ),
        8.sbh(context),
        CustomText(
          textAlign: TextAlign.center,
          text: 'take_action_now'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: themeCubit.textColor,
                fontWeight: FontWeight.w700,
              ),
        ),
        6.sbh(context),
        CustomText(
          textAlign: TextAlign.center,
          text: 'immediate_intro'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: themeCubit.unselectedColor,
                height: 1.5,
              ),
        ),
        18.sbh(context),
        ..._actions.map((a) => Padding(
              padding: EdgeInsets.only(bottom: resp.hp(10)),
              child: _ActionRow(action: a, themeCubit: themeCubit, resp: resp),
            )),
        14.sbh(context),
        CustomContainer(
          padding: EdgeInsets.all(resp.wp(12)),
          borderRadius: resp.radius(14),
          color: AppColors.primary.withValues(alpha: 0.08),
          child: Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: AppColors.primary, size: resp.fontSize(20)),
              10.sbw(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'small_actions_title'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: themeCubit.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    CustomText(
                      text: 'small_actions_msg'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeCubit.unselectedColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        20.sbh(context),
        CustomButton(
          text: 'complete_log'.tr(),
          onTap: () {
            final flow = context.read<UrgeFlowCubit>();
            context.read<UrgeLogCubit>().addEntry(flow.buildLogEntry());
            flow.reset();
            context.read<BottomBarCubit>().changeTab(0);
          },
          borderRadius: resp.radius(14),
          height: resp.hp(52),
          textSize: resp.fontSize(16),
        ),
      ],
    );
  }
}

class _QuickAction {
  final String key;
  final IconData icon;
  const _QuickAction(this.key, this.icon);
}

class _ActionRow extends StatelessWidget {
  final _QuickAction action;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const _ActionRow({
    required this.action,
    required this.themeCubit,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(
        horizontal: resp.wp(14),
        vertical: resp.hp(14),
      ),
      borderRadius: resp.radius(14),
      color: themeCubit.containerColor,
      border: Border.all(
        color: themeCubit.greyColor.withValues(alpha: 0.4),
        width: 0.6,
      ),
      child: Row(
        children: [
          Icon(action.icon,
              color: AppColors.primary, size: resp.fontSize(20)),
          12.sbw(context),
          Expanded(
            child: CustomText(
              text: action.key.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    ).onTap(() {
      // Surface a small confirmation so the user knows the tap registered.
      // We don't navigate away — the "Complete Log" button still saves.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1200),
          backgroundColor: AppColors.primary,
          content: Text(action.key.tr()),
        ),
      );
    });
  }
}
