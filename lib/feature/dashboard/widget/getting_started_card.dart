
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/common_widget/custom_conrtainer.dart';
import '../../../common/common_widget/custom_text.dart';
import '../../../common/extensions/sized_box.dart';
import '../../../common/utils/responsive_helper/responsive_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/cubit/theme_cubit.dart';
import '../../dashboard/cubit/dashboard_cubit.dart';

class GettingStartedCard extends StatelessWidget {
  final ResponsiveHelper resp;
  final ThemeCubit themeCubit;
  final String Function(int) titleBuilder;
  final String Function(int) descBuilder;

  const GettingStartedCard({
    super.key,
    required this.resp,
    required this.themeCubit,
    required this.titleBuilder,
    required this.descBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupProgressCubit, SetupProgressState>(
      builder: (context, state) {
        final step = state.step;
        final total = SetupProgressCubit.totalSteps;
        final progress = step / total;

        return CustomContainer(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: resp.wp(12), vertical: resp.hp(20)),
          borderRadius: resp.radius(24),
          color: themeCubit.containerColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: resp.hp(40),
                width: resp.hp(40),
                borderRadius: resp.radius(12),
                color: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary),
              ),
              10.sbw(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: resp.wp(220),
                          child: CustomText(
                            maxLines: 1,
                            overflow: true,
                            text: titleBuilder(step),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: themeCubit.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (step < total)
                          InkWell(
                            onTap: () =>
                                context.read<SetupProgressCubit>().next(),
                            borderRadius: BorderRadius.circular(50),
                            child: CustomContainer(
                              height: resp.hp(32),
                              width: resp.wp(32),
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(.1),
                              
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    8.sbh(context),
                    CustomText(
                      text: descBuilder(step),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeCubit.unselectedColor,
                            height: 1.5,
                          ),
                    ),
                    24.sbh(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "setup_progress".tr().toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: themeCubit.textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                        ),
                        CustomText(
                          text: "$step/$total",
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: themeCubit.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    8.sbh(context),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: themeCubit.greyColor.withOpacity(0.1),
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}