import 'dart:ui';
import 'package:attention_anchor/feature/habit_creation/cubit/habit_cubit.dart';
import 'package:attention_anchor/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:attention_anchor/feature/localization/cubit/language_cubit.dart';
import 'package:attention_anchor/feature/localization/cubit/language_state.dart';
import 'package:attention_anchor/feature/localization/page/localization_page.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:attention_anchor/theme/theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message received: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC57CLJ4zE7cILekq-t57LV11It2Qou1gA',
      appId: '1:520484636432:android:c57394915f8e1d27e54795',
      messagingSenderId: '520484636432',
      projectId: 'plant-identifier---plant-care',
      storageBucket: 'plant-identifier---plant-care.firebasestorage.app',
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver(analytics: analytics);
  }
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
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
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
                  child: child??Container(),
                );
              },
              home:  SelectLanguageScreen(showBackButton: false,),
            );
          },
        );
      },
    );
  }
}