
// import 'package:fitness/common/utils/force_update/model/force_update_model.dart';
// import 'package:fitness/common/utils/force_update/service/force_update_remote_service.dart';
// import 'package:fitness/common/utils/force_update/widget/dialogbox.dart';
// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class ForceUpdateManager {
//   static final ForceUpdateManager _instance = ForceUpdateManager._internal();

//   factory ForceUpdateManager() {
//     return _instance;
//   }

//   ForceUpdateManager._internal();

//   final RemoteConfigService _remoteConfigService = RemoteConfigService();

//   /// Compares version strings (e.g., "1.0.0" < "1.0.1")
//   /// Returns true if currentVersion < remoteVersion
//   bool _isVersionOutdated(String currentVersion, String remoteVersion) {
//     try {
//       final currentParts = currentVersion.split('.').map(int.parse).toList();
//       final remoteParts = remoteVersion.split('.').map(int.parse).toList();

//       // Pad with zeros if lengths differ
//       while (currentParts.length < remoteParts.length) {
//         currentParts.add(0);
//       }
//       while (remoteParts.length < currentParts.length) {
//         remoteParts.add(0);
//       }

//       for (int i = 0; i < currentParts.length; i++) {
//         if (currentParts[i] < remoteParts[i]) {
//           return true;
//         } else if (currentParts[i] > remoteParts[i]) {
//           return false;
//         }
//       }

//       return false;
//     } catch (e) {
//       debugPrint('❌ Error comparing versions: $e');
//       return false;
//     }
//   }

//   /// Checks for force update and shows dialog if needed
//   /// Should be called early in the app lifecycle
//   Future<void> checkAndShowUpdateIfNeeded(BuildContext context) async {
//     try {
//       debugPrint('🔄 Checking for force updates...');

//       // 1. Get force update config
//       final config = _remoteConfigService.getForceUpdateConfig();

//       // 2. If force_update is false, skip check
//       if (!config.forceUpdate) {
//         debugPrint('✅ Force update is disabled in config');
//         return;
//       }

//       debugPrint('⚠️ Force update is enabled in config');

//       // 3. Get current app version
//       final packageInfo = await PackageInfo.fromPlatform();
//       final currentVersion = packageInfo.version;

//       debugPrint(
//         '📱 Current version: $currentVersion, Remote version: ${config.latestVersion}',
//       );

//       // 4. Check if update is needed
//       if (_isVersionOutdated(currentVersion, config.latestVersion)) {
//         debugPrint('🔴 Update is required!');

//         // 5. Show undismissible dialog
//         if (context.mounted) {
//           await _showForceUpdateDialog(context, config);
//         }
//       } else {
//         debugPrint('✅ App is up to date');
//       }
//     } catch (e) {
//       debugPrint('❌ Error checking for updates: $e');
//     }
//   }

//   /// Shows the force update dialog
//   Future<void> _showForceUpdateDialog(
//     BuildContext context,
//     ForceUpdateRemoteConfigModel config,
//   ) async {
//     await showForceUpdateDialog(
//       context,
//       latestVersion: config.latestVersion,
//       playStoreUrl: config.playStoreUrl,
//     );
//   }

//   //   Future<void> _openPlayStore(String playStoreUrl) async {
//   //     try {
//   //       debugPrint('🌐 Opening Play Store: $playStoreUrl');

//   //       if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
//   //         await launchUrl(
//   //           Uri.parse(playStoreUrl),
//   //           mode: LaunchMode.externalApplication,
//   //         );
//   //       } else {
//   //         debugPrint('❌ Could not launch Play Store URL');
//   //       }
//   //     } catch (e) {
//   //       debugPrint('❌ Error opening Play Store: $e');
//   //     }
//   //   }
// }
