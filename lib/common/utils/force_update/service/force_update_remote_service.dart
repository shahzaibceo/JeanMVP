// import 'dart:convert';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:fitness/common/utils/force_update/model/force_update_model.dart';
// import 'package:flutter/material.dart';

// class RemoteConfigService {
//   final remoteConfig = FirebaseRemoteConfig.instance;

//   Future<void> initialize() async {
//     try {
//       debugPrint('🔄 Initializing Remote Config...');

//       await remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 20),
//           minimumFetchInterval: Duration.zero,
//         ),
//       );

//       // 2. Set defaults as fallback
//       await remoteConfig.setDefaults({
//         'force_update_json': json.encode(_offlineForceUpdateDefaults),
//       });

//       try {
//         // 3. Force fetch new values
//         debugPrint('📡 Fetching fresh config from Firebase...');
//         await remoteConfig.fetch();

//         // 4. Activate fetched values
//         final activated = await remoteConfig.activate();
//         debugPrint(
//           activated
//               ? '✅ Remote config activated successfully!'
//               : '⚠️ Failed to activate remote config',
//         );

//         // 5. Debug current state
//         final forceUpdateValue = remoteConfig.getValue('force_update_json');

//         debugPrint('📦 Force update config source: ${forceUpdateValue.source}');
//         debugPrint(
//           '📄 Raw force update config: ${forceUpdateValue.asString()}',
//         );
//       } catch (e) {
//         debugPrint('❌ Fetch/Activate failed: $e');
//       }
//     } catch (e) {
//       debugPrint('❌ Remote config initialization failed: $e');
//     }
//   }

//   // Offline fallback values for force update
//   static final Map<String, dynamic> _offlineForceUpdateDefaults = {
//     "android": {
//       "min_version": "1.0.0",
//       "latest_version": "1.1.0",
//       "force_update": true,
//       "playstore_url":
//           "https://play.google.com/store/apps/details?id=com.plantidentifier.plantcare.plantscanner",
//     },
//   };

//   // Get Force Update Config
//   ForceUpdateRemoteConfigModel getForceUpdateConfig() {
//     try {
//       final configJson = remoteConfig.getValue('force_update_json');
//       String jsonString = configJson.asString().trim();

//       // Parse Firebase config with nested android structure
//       final fullConfig = json.decode(jsonString);
//       final model = ForceUpdateRemoteConfigModel.fromAndroidConfig(fullConfig);

//       debugPrint(
//         '✅ Force update config loaded: min=${model.minVersion}, latest=${model.latestVersion}, force=${model.forceUpdate}',
//       );
//       return model;
//     } catch (e) {
//       debugPrint(
//         '⚠️ Error getting force update config: $e. Using offline defaults.',
//       );
//       // Fall back to offline defaults
//       return ForceUpdateRemoteConfigModel.fromAndroidConfig(
//         _offlineForceUpdateDefaults,
//       );
//     }
//   }
// }
