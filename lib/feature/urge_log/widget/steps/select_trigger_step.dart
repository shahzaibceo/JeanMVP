import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
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

/// Step 2 — "Select Trigger". A scrollable list of predefined triggers
/// (each with a coloured leading dot, label, and chevron) plus an
/// "Add Custom Trigger" option that swaps the list for an inline text
/// field.
class SelectTriggerStep extends StatefulWidget {
  final ThemeCubit themeCubit;
  const SelectTriggerStep({super.key, required this.themeCubit});

  @override
  State<SelectTriggerStep> createState() => _SelectTriggerStepState();
}

class _SelectTriggerStepState extends State<SelectTriggerStep> {
  late final TextEditingController _customController;
  bool _showCustom = false;

  /// Trigger options as (key, leading-icon, accent colour) triples.
  /// Keys map to translation strings; colours are inline since they're
  /// purely decorative and never change per locale/theme.
  static const List<_Trigger> _triggers = [
    _Trigger('trigger_social_media', Icons.phone_iphone, Color(0xFF7C5CFF)),
    _Trigger('trigger_stress', Icons.bolt_outlined, Color(0xFFF97316)),
    _Trigger('trigger_boredom', Icons.sentiment_neutral, Color(0xFFFACC15)),
    _Trigger('trigger_anxiety', Icons.psychology_alt_outlined, Color(0xFF22C55E)),
    _Trigger('trigger_overthinking', Icons.cyclone, Color(0xFF8B5CF6)),
    _Trigger('trigger_laziness', Icons.bedtime_outlined, Color(0xFFFB923C)),
    _Trigger('trigger_anger', Icons.local_fire_department_outlined, Color(0xFFEF4444)),
    _Trigger('trigger_loneliness', Icons.person_outline, Color(0xFF60A5FA)),
  ];

  @override
  void initState() {
    super.initState();
    final initial = context.read<UrgeFlowCubit>().state.customTrigger;
    _customController = TextEditingController(text: initial);
    _showCustom = initial.isNotEmpty;
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final theme = widget.themeCubit;

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) =>
          a.selectedTrigger != b.selectedTrigger ||
          a.customTrigger != b.customTrigger,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            12.sbh(context),
            ..._triggers.map((t) => Padding(
                  padding: EdgeInsets.only(bottom: resp.hp(10)),
                  child: _TriggerTile(
                    trigger: t,
                    isSelected: state.selectedTrigger == t.key,
                    themeCubit: theme,
                    resp: resp,
                    onTap: () {
                      setState(() => _showCustom = false);
                      _customController.clear();
                      context.read<UrgeFlowCubit>().selectTrigger(t.key);
                    },
                  ),
                )),
            8.sbh(context),
            if (_showCustom)
              CustomTextFormField(
                controller: _customController,
                readOnly: false,
                enableSuggestions: false,
                autocorrect: false,
                showBorder: true,
                hintText: 'custom_trigger_hint'.tr(),
                borderRadiusValue: 14,
                fillColor: theme.containerColor,
                onChanged: context.read<UrgeFlowCubit>().setCustomTrigger,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: resp.wp(16),
                  vertical: resp.hp(14),
                ),
              )
            else
              Row(
                children: [
                  Icon(Icons.add, color: AppColors.primary, size: resp.fontSize(20)),
                  6.sbw(context),
                  CustomText(
                    text: 'add_custom_trigger'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ).onTap(() => setState(() => _showCustom = true)),
          ],
        );
      },
    );
  }
}

class _Trigger {
  final String key;
  final IconData icon;
  final Color color;
  const _Trigger(this.key, this.icon, this.color);
}

class _TriggerTile extends StatelessWidget {
  final _Trigger trigger;
  final bool isSelected;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;
  final VoidCallback onTap;

  const _TriggerTile({
    required this.trigger,
    required this.isSelected,
    required this.themeCubit,
    required this.resp,
    required this.onTap,
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
        color: isSelected
            ? AppColors.primary
            : themeCubit.greyColor.withValues(alpha: 0.4),
        width: isSelected ? 1.4 : 0.6,
      ),
      child: Row(
        children: [
          Icon(trigger.icon, color: trigger.color, size: resp.fontSize(20)),
          12.sbw(context),
          Expanded(
            child: CustomText(
              text: trigger.key.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          // Icon(
          //   Icons.chevron_right,
          //   color: themeCubit.unselectedColor,
          //   size: resp.fontSize(20),
          // ),
        ],
      ),
    ).onTap(onTap);
  }
}
