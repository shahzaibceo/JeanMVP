// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get_storage/get_storage.dart';
// class FCMService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   static String? _fcmToken;
//   static bool _isInitialized = false;
//   // GetStorage & key
//   static final _box = GetStorage();
//   static const _key = 'notification_toggle';
//   static Future<void> initialize() async {
//     if (_isInitialized) {
//       log('⚠️ FCM already initialized');
//       return;
//     }

//     try {

//       await _requestPermissions();

//       // 2️⃣ Get token
//       _fcmToken = await getFCMToken();

//       // 3️⃣ Update GetStorage & GetX toggle automatically
//       if (_fcmToken != null) {
//         _box.write(_key, true); // save ON
//         log('✅ Notifications ON, token saved');
//       } else {
//         _box.write(_key, false); // save OFF
//         log('⚠️ Notifications OFF, token null');
//       }

    
//       _listenToTokenRefresh();
//       _handleForegroundMessages();
//       _handleNotificationOpenedApp();
//       _checkInitialMessage();

//       _isInitialized = true;
//       log('✅ FCM initialized successfully');
//     } catch (e) {
//       log('❌ FCM initialization error: $e');
//     }
//   }

//   static Future<void> _requestPermissions() async {
//     try {
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       log('📱 Permission: ${settings.authorizationStatus}');
//     } catch (e) {
//       log('❌ Permission error: $e');
//     }
//   }

//   static Future<String?> getFCMToken() async {
//     try {
//       _fcmToken = await _messaging.getToken();

//       if (_fcmToken != null) {
//         log('🔑 FCM Token: $_fcmToken');
//         return _fcmToken;
//       } else {
//         log('⚠️ FCM Token is null');
//         return null;
//       }
//     } catch (e) {
//       log('❌ Error getting token: $e');
//       return null;
//     }
//   }
// static Future<void> deleteToken() async {
//     try {
//       await _messaging.deleteToken();
//       _fcmToken = null;
//       _isInitialized = false; // allow re-init
//       _box.write(_key, false); // save OFF
//       log('🗑️ FCM Token deleted, toggle OFF');
//     } catch (e) {
//       log('❌ Error deleting FCM token: $e');
//     }
//   }

//   /// Get token anytime
//   static String? getToken() {
//     return _fcmToken;
//   }

//   /// Token refresh listener
//   static void _listenToTokenRefresh() {
//     _messaging.onTokenRefresh.listen((newToken) {
//       log('🔄 Token refreshed: $newToken');
//       _fcmToken = newToken;
//     });
//   }

//   /// Foreground notifications
//   static void _handleForegroundMessages() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('📬 Foreground message received');
//       log('Title: ${message.notification?.title}');
//       log('Body: ${message.notification?.body}');
//       log('Data: ${message.data}');
//     });
//   }

//   /// Notification tap when app is in background
//   static void _handleNotificationOpenedApp() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('🔔 App opened from notification');
//       log('Data: ${message.data}');
//     });
//   }

//   /// App opened from terminated state
//   static Future<void> _checkInitialMessage() async {
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();

//     if (initialMessage != null) {
//       log('🚀 App launched from terminated via notification');
//       log('Data: ${initialMessage.data}');
//     }
//   }

//   /// Topic subscribe
//   static Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _messaging.subscribeToTopic(topic);
//       log('📌 Subscribed to $topic');
//     } catch (e) {
//       log('❌ Topic subscribe error: $e');
//     }
//   }

//   /// Topic unsubscribe
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _messaging.unsubscribeFromTopic(topic);
//       log('📌 Unsubscribed from $topic');
//     } catch (e) {
//       log('❌ Topic unsubscribe error: $e');
//     }
//   }
// }
