import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

class TimerBox extends StatelessWidget {
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;
  final TextEditingController hController;
  final TextEditingController mController;

  const TimerBox({
    Key? key,
    required this.themeCubit,
    required this.resp,
    required this.hController,
    required this.mController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: resp.wp(16),
        vertical: resp.hp(14),
      ),
      color: themeCubit.containerColor,
      borderRadius: resp.radius(20),
      border: Border.all(color: themeCubit.greyColor, width: 0.1),
      child: Row(
        children: [
          _LabelText(label: "hours".tr(), themeCubit: themeCubit, resp: resp),
          8.sbw(context),
          SmallField(controller: hController, themeCubit: themeCubit, resp: resp),
          const Spacer(),
          _LabelText(label: "mints".tr(), themeCubit: themeCubit, resp: resp),
          8.sbw(context),
          SmallField(controller: mController, themeCubit: themeCubit, resp: resp),
        ],
      ),
    );
  }
}

class SmallField extends StatelessWidget {
  final TextEditingController controller;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const SmallField({
    Key? key,
    required this.controller,
    required this.themeCubit,
    required this.resp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: resp.hp(45),
      width: resp.wp(60),
      child: CustomTextFormField(
        controller: controller,
        readOnly: false,
        enableSuggestions: false,
        autocorrect: false,
        showBorder: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        borderRadiusValue: 12,
        fillColor: themeCubit.containerColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: resp.wp(8),
          vertical: resp.hp(12),
        ),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: themeCubit.textColor,
              fontWeight: FontWeight.w700,
              fontSize: resp.fontSize(16),
            ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String label;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const _LabelText({
    Key? key,
    required this.label,
    required this.themeCubit,
    required this.resp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: label,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: themeCubit.textColor,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}