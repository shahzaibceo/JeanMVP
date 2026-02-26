import 'package:flutter/material.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';

class HabitNameField extends StatelessWidget {
  final TextEditingController controller;
  final ThemeCubit themeCubit;
  final ResponsiveHelper resp;

  const HabitNameField({
    super.key,
    required this.controller,
    required this.themeCubit,
    required this.resp,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
         readOnly: false,
                enableSuggestions: false,
                autocorrect: false,
                showBorder: true,
       textAlign: TextAlign.center,
      controller: controller,
      hintText: "enter_name_here".tr(),
      borderRadiusValue: 16,
      fillColor: themeCubit.containerColor,
   enableBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: themeCubit.greyColor, 
      width: 0.1, 
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: themeCubit.greyColor, 
      width: 0.5, 
    ),
  ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: resp.wp(16),
        vertical: resp.hp(18),
      ),
    );
  }
}