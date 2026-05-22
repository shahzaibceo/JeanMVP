import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/feature/urge_log/widget/urge_gauge_widget.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 1 — "Log Urge". Centres on a draggable half-circle gauge with a
/// short reassurance and a colour-coded severity legend below it.
class LogUrgeStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const LogUrgeStep({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) => a.urgeRating != b.urgeRating,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'how_strong_urge'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: themeCubit.textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            24.sbh(context),
            Center(
              child: UrgeGaugeWidget(
                value: state.urgeRating,
                onChanged: context.read<UrgeFlowCubit>().setUrgeRating,
                themeCubit: themeCubit,
              ),
            ),
            16.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'urge_reassurance'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.unselectedColor,
                    height: 1.5,
                  ),
            ),
            12.sbh(context),
            const Center(child: Text('❤️', style: TextStyle(fontSize: 18))),
            24.sbh(context),
            _Legend(themeCubit: themeCubit, resp: resp),
          ],
        );
      },
    );
  }
}

/// Severity legend (1-3 Mild ... 8-10 Very High) shown beneath the gauge.
class _Legend extends StatelessWidget {
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;
  const _Legend({required this.themeCubit, required this.resp});

  static final _rows = [
    _LegendRow('1-3', 'severity_mild'.tr(), 'severity_mild_action'.tr(), const Color(0xFF22C55E)),
     _LegendRow('4-5', 'severity_moderate'.tr(), 'severity_moderate_action'.tr(), Color(0xFFFACC15)),
     _LegendRow('6-7', 'severity_high'.tr(), 'severity_high_action'.tr(), Color(0xFFF97316)),
       _LegendRow('8-10', 'severity_very_high'.tr(), 'severity_very_high_action'.tr(), Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(
        horizontal: resp.wp(16),
        vertical: resp.hp(14),
      ),
      borderRadius: resp.radius(16),
      color: themeCubit.containerColor,
      border: Border.all(color: themeCubit.greyColor, width: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'legend_title'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeCubit.textColor,
                  fontWeight: FontWeight.w900,
                ),
          ),
          10.sbh(context),
          ..._rows.map((r) => Padding(
                padding: EdgeInsets.symmetric(vertical: resp.hp(3)),
                child: Row(
                  children: [
                    
                    // CustomContainer(
                    //   width: resp.wp(8),
                    //   height: resp.wp(8),
                    //   shape: BoxShape.circle,
                    //   color: r.dot,
                    // ),
                    // 8.sbw(context),
                    // SizedBox(
                    //   width: resp.wp(40),
                    //   child: CustomText(
                    //     text: r.range,
                    //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    //           color: themeCubit.textColor,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //   ),
                    // ),
                       /// Range pill container
    CustomContainer(
      padding: EdgeInsets.symmetric(
        horizontal: resp.wp(12),
        vertical: resp.hp(6),
      ),
      borderRadius: resp.radius(30),
      color: r.dot.withValues(alpha: 0.12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Small colored dot
          CustomContainer(
            width: resp.wp(8),
            height: resp.wp(8),
            shape: BoxShape.circle,
            color: r.dot,
          ),

          6.sbw(context),

          /// Range text
          CustomText(
            text: r.range,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: r.dot,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    ),
                    10.sbw(context),  
                    SizedBox(
                      width: resp.wp(80),
                      child: CustomText(
                        text: r.labelKey.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: themeCubit.textColor,
                            ),
                      ),
                    ),
                    Spacer(),
                    CustomText(
                      text: r.actionKey.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: themeCubit.unselectedColor,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _LegendRow {
  final String range;
  final String labelKey;
  final String actionKey;
  final Color dot;
  const _LegendRow(this.range, this.labelKey, this.actionKey, this.dot);
}
