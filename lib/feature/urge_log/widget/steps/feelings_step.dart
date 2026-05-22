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

/// Step 3 — "How did this make you feel?" 3×3 grid of colour-tinted
/// emoji tiles. Multi-select.
class FeelingsStep extends StatelessWidget {
  final ThemeCubit themeCubit;
  const FeelingsStep({super.key, required this.themeCubit});

  /// Order mirrors the design: row 1 reds/oranges, row 2 cool tones,
  /// row 3 positive/neutral.
  static const List<_Feeling> _feelings = [
    _Feeling('feeling_frustrated', '😣', Color(0xFFFEE2E2)),
    _Feeling('feeling_overwhelmed', '😞', Color(0xFFFEF3C7)),
    _Feeling('feeling_bored', '😐', Color(0xFFFEF9C3)),
    _Feeling('feeling_anxious', '😰', Color(0xFFDCFCE7)),
    _Feeling('feeling_lonely', '🥺', Color(0xFFDBEAFE)),
    _Feeling('feeling_curious', '🤔', Color(0xFFFEF3C7)),
    _Feeling('feeling_excited', '😍', Color(0xFFFCE7F3)),
    _Feeling('feeling_relaxed', '😌', Color(0xFFFCE7F3)),
    _Feeling('feeling_other', '⋯', Color(0xFFE5E7EB)),
  ];

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) => a.selectedFeelings != b.selectedFeelings,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            12.sbh(context),
            CustomText(
              textAlign: TextAlign.center,
              text: 'be_honest'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: themeCubit.unselectedColor,
                  ),
            ),
            20.sbh(context),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: resp.hp(12),
              crossAxisSpacing: resp.wp(12),
              childAspectRatio: 1,
              children: _feelings
                  .map((f) => _FeelingTile(
                        feeling: f,
                        isSelected: state.selectedFeelings.contains(f.key),
                        themeCubit: themeCubit,
                        resp: resp,
                        onTap: () =>
                            context.read<UrgeFlowCubit>().toggleFeeling(f.key),
                      ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _Feeling {
  final String key;
  final String emoji;
  final Color tint;
  const _Feeling(this.key, this.emoji, this.tint);
}

class _FeelingTile extends StatelessWidget {
  final _Feeling feeling;
  final bool isSelected;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;
  final VoidCallback onTap;

  const _FeelingTile({
    required this.feeling,
    required this.isSelected,
    required this.themeCubit,
    required this.resp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(resp.wp(10)),
      borderRadius: resp.radius(16),
      color: themeCubit.containerColor,
      border: Border.all(
        color: isSelected
            ? AppColors.primary
            : themeCubit.greyColor.withValues(alpha: 0.4),
        width: isSelected ? 1.6 : 0.6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomContainer(
            width: resp.wp(46),
            height: resp.wp(46),
            shape: BoxShape.circle,
            color: feeling.tint,
            alignment: Alignment.center,
            child: Text(
              feeling.emoji,
              style: TextStyle(fontSize: resp.fontSize(22)),
            ),
          ),
          8.sbh(context),
          CustomText(
            text: feeling.key.tr(),
            maxLines: 1,
            overflow: true,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: themeCubit.textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    ).onTap(onTap);
  }
}
