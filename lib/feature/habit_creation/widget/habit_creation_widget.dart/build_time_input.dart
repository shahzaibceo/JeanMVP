  import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/habit_creation/widget/habit_creation_widget.dart/build_time_box.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
 Widget buildTimeInputCard(BuildContext context, ThemeCubit theme, ResponsiveHelper resp, TextEditingController h, TextEditingController m, String p, Function(String) onP) {
    return CustomContainer(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: resp.wp(16), vertical: resp.hp(14)),
      color: theme.containerColor,
      borderRadius: resp.radius(20),
      border: Border.all(color: theme.greyColor, width: 0.1)  ,
      child: Row(
        children: [
          CustomText(text: "hours".tr(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:   theme.textColor,
                    fontWeight: FontWeight.w400,
                  ),),
          8.sbw(context),
          buildSmallField(h, theme, resp,context),
          12.sbw(context),
          CustomText(text: "mints".tr(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.textColor,
                    fontWeight: FontWeight.w400,
                  ),),
          8.sbw(context),
          buildSmallField(m, theme, resp,context,),
          const Spacer(),
          Column(
            children: [
              buildRadioOption("am", p, theme, resp, onP, context),
              8.sbh(context),
              buildRadioOption("pm", p, theme, resp, onP, context),
            ],
          )
        ],
      ),
    );
  }
 Widget buildRadioOption(String value, String current, ThemeCubit theme, ResponsiveHelper resp, Function(String) onTap,BuildContext context) {
    bool isSelected = value == current;
    return Row(
      children: [
        CustomContainer(
          height: resp.wp(20),
          width: resp.wp(20),
          borderRadius: resp.radius(50),
          border: Border.all(color: AppColors.primary, width: 1.5),
          color: isSelected ? AppColors.primary : Colors.transparent,
          child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
        ).onTap(() => onTap(value)),
        8.sbw(context),
        CustomText(text: value.tr(), style: 
        Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:   theme.textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
                  ),
     ),
      ],
    );
  }