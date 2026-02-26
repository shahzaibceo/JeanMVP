
  import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';

Widget buildTimerBox({
  required ThemeCubit themeCubit,
  required ResponsiveHelper resp,
  required BuildContext context,
  required TextEditingController hController,
  required TextEditingController mController,
}) {
  return CustomContainer(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: resp.wp(16), vertical: resp.hp(14)),
    color: themeCubit.containerColor,
    borderRadius: resp.radius(20),
    border: Border.all(color: themeCubit.greyColor, width: 0.1)  ,
    child: Row(
      children: [
        CustomText(
          text: "hours".tr(), 
          style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:   themeCubit.textColor,
                    fontWeight: FontWeight.w500
                  ),
        ),
        8.sbw(context),
        // Hours field
      buildSmallField(hController, themeCubit, resp, context),
        const Spacer(),
        CustomText(
          text: "mints".tr(), 
          style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:   themeCubit.textColor,
                    fontWeight: FontWeight.w500
                  ),
        ),
        8.sbw(context),
        buildSmallField(mController, themeCubit, resp, context),
      ],
    ),
  );
}

  
  Widget buildSmallField(TextEditingController controller, ThemeCubit theme, ResponsiveHelper resp,BuildContext context) {
    return SizedBox(
      height: resp.hp(45),
      width: resp.wp(65),
      child: CustomTextFormField(
        contentPadding: EdgeInsets.symmetric(horizontal: resp.wp(8), vertical: resp.hp(12)),
        readOnly: false,
        enableSuggestions: false,
        autocorrect: false,
        showBorder: true,
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        borderRadiusValue: 12,
        fillColor: theme.containerColor,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: theme.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: resp.fontSize(16),
                    ),
      ),
    );
  }
