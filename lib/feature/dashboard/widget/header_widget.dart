import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attention_anchor/feature/dashboard/cubit/dashboard_view_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../theme/cubit/theme_cubit.dart';

class HeaderSection extends StatelessWidget {
  final ThemeCubit themeCubit;

  const HeaderSection({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final dashboardViewState = context.watch<DashboardViewCubit>().state;
    final selectedDate = dashboardViewState.selectedDate;
    final langCode = LocalizationService.instance.selectedLanguageCode;

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
          text: DateFormat('EEEE, MMM d', langCode).format(selectedDate),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: themeCubit.textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}