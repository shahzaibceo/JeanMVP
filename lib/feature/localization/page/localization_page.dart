import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/custom_text_field.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/localization/cubit/language_cubit.dart';
import 'package:attention_anchor/feature/onboarding/page/onboarding_screen.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectLanguageScreen extends StatefulWidget {
  final bool showBackButton;
  const SelectLanguageScreen({super.key, this.showBackButton = true});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}
class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  Analytics
    FirebaseAnalytics.instance.logScreenView(screenName: "select_language_screen");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();
    final languageCubit = context.watch<LanguageCubit>();
    final langState = languageCubit.state;

    return MainBackground(
      appBar: AppBarWidget(
          showBack: widget.showBackButton,
          title: "languages".tr(),
          actions: [
            IconButton(
              onPressed: () {
                 Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>  OnboardingScreen()),
      );
              },
              icon: SvgPicture.asset(AppIcons.tick, color: themeCubit.textColor, width: resp.wp(20)),
            ),
          ],
        ),
      child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.sbh(context),
      
              // Search Field
              CustomTextFormField(
                controller: searchController,
                readOnly: false,
                enableSuggestions: true,
                autocorrect: true,
                hintText: "search_language".tr(),
                onChanged: (value) => languageCubit.updateSearchQuery(value),
                fillColor: themeCubit.containerColor,
                contentPadding: EdgeInsets.symmetric(vertical: resp.hp(16)),
                showBorder: false,
                borderRadiusValue: 16,
                prefixIconPadding: EdgeInsets.only(left: resp.wp(16), right: resp.wp(12)),
                prefixIcon: CustomContainer(
                   height: resp.hp(40),
                   width:resp.wp(40),
                  borderRadius: resp.radius(10),
                  color: AppColors.primary.withOpacity(0.15),
                  child:SvgPicture.asset(AppIcons.search, color: AppColors.primary, width: resp.wp(20),fit: BoxFit.scaleDown,),
                ),
                suffixIconPadding: EdgeInsets.only(right: resp.wp(16)),
                suffixIcon: Icon(
                  Icons.chevron_right,
                  color:  themeCubit.unselectedColor,
                  size: 24,
                ),
              ).withSymmetricPadding(horizontal: resp.wp(16)),
      
              25.sbh(context),
              CustomText(
                text: "select_language".tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: themeCubit.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: resp.fontSize(16),
                    ),
              ).withSymmetricPadding(horizontal: resp.wp(16)),
              15.sbh(context),
      
              // Language List
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: resp.wp(16)),
                    itemCount: languageCubit.filteredLanguages.length,
                    itemBuilder: (context, index) {
                      final lang = languageCubit.filteredLanguages[index];
                      final isSelected = langState.selectedLanguage == lang["name"];
                      final code = lang["code"];
      
                      return CustomContainer(
                        margin: EdgeInsets.symmetric(vertical: resp.hp(6)),
                        padding: EdgeInsets.symmetric(
                          horizontal: resp.wp(12),
                          vertical: resp.hp(10),
                        ),
                        color: isSelected ? AppColors.primary : themeCubit.containerColor,
                        borderRadius: resp.radius(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        child: Row(
                          children: [
                            CustomContainer(
                              height: resp.hp(45),
                              width: resp.wp(40),
                              borderRadius: resp.radius(12),
                              color: isSelected ? null : AppColors.primary.withOpacity(0.1),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: code != null && code.isNotEmpty 
                                    ? CircleFlag(code, size: resp.wp(28))
                                    : Icon(Icons.language, size: resp.wp(28), color: Colors.grey),
                                ),
                              ),
                            ),
                            16.sbw(context),
                            Expanded(
                              child: CustomText(
                                text: lang["name"] ?? "Unknown",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: isSelected ? AppColors.white : themeCubit.unselectedColor,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_off,
                              color: isSelected ? AppColors.white : themeCubit.unselectedColor,
                              size: resp.wp(20),
                            ),
                            8.sbw(context),
                          ],
                        ),
                      ).onTap(() {
                        languageCubit.selectLanguage(lang["name"]!);
                      });
                    },
                  ),
                ),
              ),
              40.sbh(context),
            ],
          ),
        ),
    );
  }
}