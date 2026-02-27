
import 'package:attention_anchor/common/common_widget/app_bar.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart' show CustomText;
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/constants/image_strings/app_icons.dart';
import 'package:attention_anchor/common/extensions/padding_extension.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/services/analytics_services.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/page/bottomnav_page.dart';
import 'package:attention_anchor/feature/habit_creation/page/habit_creation_screen.dart';
import 'package:attention_anchor/feature/localization/cubit/language_cubit.dart';
import 'package:attention_anchor/feature/localization/cubit/language_state.dart';
import 'package:attention_anchor/feature/localization/page/localization_page.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/onboarding/page/onboarding_screen.dart';
import 'package:attention_anchor/feature/settings/widgets/setting_list_tile.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    FirebaseAnalytics.instance.logScreenView(screenName: "settings_screen");
    final resp = ResponsiveHelper(context);

    return MainBackground(
        appBar: AppBarWidget(
          title: "settings".tr(),
          showBack: true,
          onTap: () => Navigator.of(context).pop(),
        ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: ListView(
          children: [
            _buildSectionTitle(context, 'general_setting'.tr(), themeCubit, resp),
            
            // Language Tile
            buildSettingTile(
              iconPath: AppIcons.language,
              title: 'language'.tr(),
              trailing: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  return CustomText(
                    text: state.selectedLanguage.split(' ').first,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: themeCubit.unselectedColor,
                        ),
                  );
                },
              ),
              context: context,
              onTap: () {
                AnalyticsService.logEvent("language_selected_clicked");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SelectLanguageScreen(showBackButton: true)),
                );
              },
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            10.sbh(context),

            // Notifications Tile
            buildSettingTile(
              iconPath: AppIcons.notification,
              title: 'notifications'.tr(),
              showChevron: false,
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isNotificationOn,
                  onChanged: (val) {
                    setState(() {
                      isNotificationOn = val;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            10.sbh(context),

            // Appearance Tile
            buildSettingTile(
              iconPath: AppIcons.theme,
              title: 'appearance'.tr(),
              trailing: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return CustomText(
                    text: state.mode.trKey.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: themeCubit.unselectedColor,
                        ),
                  );
                },
              ),
              context: context,
              onTap: () => _showThemeDialog(context, themeCubit),
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            20.sbh(context),

            // Data & Privacy Policy Section
            _buildSectionTitle(context, 'data_privacy_policy'.tr(), themeCubit, resp),
            
            // About Us
            buildSettingTile(
              iconPath: AppIcons.aboutUs,
              title: 'about_us'.tr(),
              onTap: () {
                AnalyticsService.logEvent("about_us_clicked");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(  
       )),
                );
              },
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            // How To Use
            buildSettingTile(
              iconPath: AppIcons.howToUse,
              title: 'how_to_use'.tr(),
              onTap: () {
                AnalyticsService.logEvent("how_to_use_clicked");
               Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            // Privacy Policy
            buildSettingTile(
              iconPath: AppIcons.privacy,
              title: 'privacy_policy'.tr(),
               onTap: () {
                   Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HabitCreationView()),
                );
               },

              // onTap: () async {
              //   AnalyticsService.logEvent("privacy_policy_clicked");
              //   final url = Uri.parse('https://sites.google.com/devtrixsol.com/livewallpaperapp/home');
              //   await launchUrl(url, mode: LaunchMode.inAppWebView);
              // },
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            // Share
            buildSettingTile(
              iconPath: AppIcons.share,
              title: 'share'.tr(),
              // onTap: () {
              //   AnalyticsService.logEvent("share_clicked");
              //   Share.share("Check out this amazing App!\nhttps://play.google.com/store/apps/details?id=com.recipekeeper.mealplanner.recipebook");
              // },
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            // Rate Us
            buildSettingTile(
              iconPath: AppIcons.rate,
              title: 'rate_us'.tr(),
              // onTap: () async {
              //   AnalyticsService.logEvent("rate_us_clicked");
              //   const packageName = "com.recipekeeper.mealplanner.recipebook";
              //   final Uri uri = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");
              //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              //     debugPrint('Could not launch $uri');
              //   }
              // },
              context: context,
            ).withSymmetricPadding(horizontal: resp.wp(20)),

            20.sbh(context),
          ],
        ),
      ),
  );
}

  Widget _buildSectionTitle(BuildContext context, String text, ThemeCubit theme, ResponsiveHelper resp) {
    return CustomText(
      text: text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textColor,
          ),
    ).withSymmetricPadding(horizontal: resp.wp(20), vertical: resp.wp(10));
  }

  void _showThemeDialog(BuildContext context, ThemeCubit themeCubit) {
    final resp = ResponsiveHelper(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: themeCubit.containerColor,
        shape: RoundedRectangleBorder(borderRadius: resp.borderRadius(20.0)),
        child: Padding(
          padding: EdgeInsets.all(resp.wp(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'app_theme'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: themeCubit.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: themeCubit.textColor),
                  ),
                ],
              ),
              20.sbh(context),
              _buildThemeOption(context, 'system_default'.tr(), AppThemeMode.system, themeCubit, resp),
              _buildThemeOption(context, 'light_mode'.tr(), AppThemeMode.light, themeCubit, resp),
              _buildThemeOption(context, 'dark_mode'.tr(), AppThemeMode.dark, themeCubit, resp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, AppThemeMode mode, ThemeCubit themeCubit, ResponsiveHelper resp) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isSelected = state.mode == mode; 
        return InkWell(
          onTap: () {
            context.read<ThemeCubit>().setTheme(mode); 
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: resp.hp(15.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: themeCubit.textColor.withOpacity(isSelected ? 1.0 : 0.7),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? themeCubit.textColor : themeCubit.textColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: isSelected
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeCubit.textColor,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}