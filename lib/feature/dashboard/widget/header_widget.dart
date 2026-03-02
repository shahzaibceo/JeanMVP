import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../theme/cubit/theme_cubit.dart';

class HeaderSection extends StatelessWidget {
  final ThemeCubit themeCubit;

  const HeaderSection({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final langCode = LocalizationService.instance.selectedLanguageCode;
    final dayFormat = DateFormat('EEEE, MMM d', langCode).format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "today".tr(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: themeCubit.unselectedColor.withOpacity(0.6),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
        4.sbh(context),
        CustomText(
          text: dayFormat,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: themeCubit.textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}