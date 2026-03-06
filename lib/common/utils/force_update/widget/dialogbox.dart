
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> showForceUpdateDialog(
  BuildContext context, {
  required String latestVersion,
  required String playStoreUrl,
}) {
   final themeCubit = context.watch<ThemeCubit>();
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: CustomText(
            text: "update_required".tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: CustomText(
            text: "update_message".tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: themeCubit.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final url = Uri.parse(playStoreUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: CustomText(text:"Could not open the Play Store URL")),
                  );

                }
              },
              child: CustomText(
                text: "update_now".tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
