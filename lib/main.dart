import 'dart:developer';
import 'dart:ui';
import 'package:attention_anchor/feature/dashboard/cubit/dashboard_view_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/bottom_nav/page/bottomnav_page.dart';
import 'package:attention_anchor/feature/dashboard/cubit/dashboard_cubit.dart';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attention_anchor/feature/habit_creation/notification_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:attention_anchor/feature/localization/cubit/language_cubit.dart';
import 'package:attention_anchor/feature/localization/page/localization_page.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/theme/theme.dart';
import 'package:attention_anchor/common/utils/fcm_service/cubit/notification_cubit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("🔴 Background message received:");
  log("   Title: ${message.notification?.title}");
  log("   Body: ${message.notification?.body}");
  log("   Data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  await NotificationHelper.initialize();
  await initializeDateFormatting();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCiWFyHePbnoVx1BdK5SNgyKV7w8PL7Ow0',
      appId: '1:1098629987702:android:fcf0fe43de76d68f4ace57',
      messagingSenderId: '1098629987702',
      projectId: 'attentionanchor-6f8fe',
      storageBucket: 'attentionanchor-6f8fe.firebasestorage.app',
    ),
  );


    // if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver(analytics: analytics);
  // }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
         BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(create: (_) => HabitCubit()),
          BlocProvider(create: (_) => BottomBarCubit()),
           BlocProvider(create: (_) => SetupProgressCubit()),
           BlocProvider(create: (_) => DashboardViewCubit()),
           BlocProvider(create: (_) => NotificationCubit()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

    @override
Widget build(BuildContext context) {
  final themeState = context.watch<ThemeCubit>().state;
  final langState = context.watch<LanguageCubit>().state;
  final onboardingState = context.watch<OnboardingCubit>().state;

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Attention Anchor",
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeState.themeMode,
    locale: Locale(langState.selectedLanguageCode),
    builder: (context, child) {
      return Directionality(
        textDirection: langState.selectedLanguageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: child ?? const SizedBox(),
      );
    },
    home: onboardingState.isCompleted
        ? const BottomNavigationBarScreen()
        : const SelectLanguageScreen(showBackButton: false),
  );
}

}