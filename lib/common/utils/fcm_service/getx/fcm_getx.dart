
// import 'package:fitness/common/utils/fcm_service/fcm_service.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// class NotificationController extends GetxController {
//   RxBool isNotificationOn = false.obs; // UI toggle
//   final _box = GetStorage(); 
//   final _key = 'notification_toggle';

//   @override
//   void onInit() {
//     super.onInit();

//     // 1️⃣ Load toggle from storage
//     bool savedValue = _box.read(_key) ?? false;
//     isNotificationOn.value = savedValue;

//     // 2️⃣ Initialize FCM if previously ON or if Token already exists (sync)
//     if (savedValue || FCMService.getToken() != null) {
//       _initializeFCMAndSyncToggle();
//     }

//     // 3️⃣ Listen to toggle changes and sync with FCM + storage
//     ever(isNotificationOn, (val) async {
//       if (val) {
//         // ON → initialize FCM
//         await _initializeFCMAndSyncToggle();
//       } else {
//         // OFF → delete token
//         await FCMService.deleteToken();
//       }
//       // Write to storage only if value differs to avoid loop (though write doesn't trigger listenKey usually for same isolate? It might.)
//       if (_box.read(_key) != val) {
//          _box.write(_key, val);
//       }
//     });

//     // 4️⃣ Listen to Storage Changes (Sync from FCMService)
//     _box.listenKey(_key, (val) {
//       if (val is bool && isNotificationOn.value != val) {
//         isNotificationOn.value = val;
//       }
//     });
//   }

//   /// Handles FCM initialization and updates toggle after token is ready
//   Future<void> _initializeFCMAndSyncToggle() async {
//     await FCMService.initialize();
//     bool tokenExists = FCMService.getToken() != null;

//     // Update toggle only after token is ready
//     if (isNotificationOn.value != tokenExists) {
//       isNotificationOn.value = tokenExists;
//     }

//     // Save state
//     _box.write(_key, tokenExists);
//   }

//   /// Manual toggle from UI
//   Future<void> toggleNotification(bool val) async {
//     isNotificationOn.value = val; 
//   }
// }
