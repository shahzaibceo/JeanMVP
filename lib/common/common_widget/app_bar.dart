import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final bool showBack;
  final VoidCallback? onTap;
  final bool centerTitle;

  const AppBarWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.titleStyle,
    this.onTap,
    this.showBack = true,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();

    return AppBar(
      leadingWidth: resp.wp(70),
      centerTitle: centerTitle,
      leading: leading ??
          (showBack
              ? Center(
                  child: CustomContainer(
                    height: resp.hp(44),
                    width: resp.wp(44),
                    borderRadius: resp.radius(12),
                    color: AppColors.primary.withOpacity(0.2),
                    child: Icon(Icons.chevron_left, color: themeCubit.textColor, size: 28),
                  ).onTap(onTap ?? () => Navigator.of(context).pop()),
                ).withSymmetricPadding(horizontal: resp.wp(10))
              : null),
      title: CustomText(
        text: title ?? "",
        style: titleStyle ??
            Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: themeCubit.textColor,
                  fontWeight: FontWeight.w700,
                ),
      ),
      actions: [
        if (actions != null) ...actions!,
        10.sbw(context),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}