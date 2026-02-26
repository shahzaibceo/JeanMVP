
// import 'package:fitness/common/common_widget/custom_text.dart';
// import 'package:fitness/theme/app_colors.dart';
// import 'package:fitness/theme/getx/theme_getx.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:get/get.dart';

// Future<void> showForceUpdateDialog(
//   BuildContext context, {
//   required String latestVersion,
//   required String playStoreUrl,
// }) {
//   final ThemeController themeController = Get.find<ThemeController>();
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: () async => false,
//         child: AlertDialog(
//           title: CustomText(
//             text: "update_required".tr,
//             style: Theme.of(context).textTheme.titleSmall?.copyWith(
//               color: AppColors.primary,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           content: CustomText(
//             text: "update_message".tr,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//               color: themeController.textColor,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 final url = Uri.parse(playStoreUrl);
//                 if (await canLaunchUrl(url)) {
//                   await launchUrl(url, mode: LaunchMode.externalApplication);
//                 } else {
//                   Get.snackbar("Error", "Could not open the Play Store URL");
//                 }
//               },
//               child: CustomText(
//                 text: "update_now".tr,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
