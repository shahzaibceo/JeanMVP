
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

Widget buildSettingTile({
  required String iconPath,
  required String title,
  Widget? trailing,
  VoidCallback? onTap,
  required BuildContext context,
  bool showChevron = true,
}) {
  final themeCubit = context.watch<ThemeCubit>();
  final resp = ResponsiveHelper(context);
  return CustomContainer(
    height: resp.hp(70),
    margin: EdgeInsets.only(bottom: resp.hp(16)),
    padding: EdgeInsets.symmetric(
      horizontal: resp.wp(16),
      vertical: resp.hp(12),
    ),
    color: themeCubit.containerColor,
    borderRadius: resp.radius(16),
    child: Row(
      children: [
        CustomContainer(
          height: resp.hp(42),
          width: resp.wp(42),
          borderRadius: resp.radius(10),
          color: AppColors.primary.withOpacity(0.1),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: resp.wp(22),
              height: resp.hp(22),
              colorFilter: ColorFilter.mode(
                themeCubit.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        16.sbw(context),
        Expanded(
          child: CustomText(
            text: title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: themeCubit.unselectedColor,
                ),
          ),
        ),
        if (trailing != null) ...[
          trailing,
          if (showChevron) 8.sbw(context),
        ],
        if (showChevron)
          Icon(
            Icons.chevron_right,
            color: themeCubit.textColor,
            size: 24,
          ),
      ],
    ),
  ).onTap(onTap ?? () {});
}
