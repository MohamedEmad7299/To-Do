
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/core/routing/app_router.dart';
import 'package:to_do/core/theme/app_theme.dart';
import 'package:to_do/core/theme/theme_bloc.dart';
import 'package:to_do/core/theme/theme_event.dart';
import 'package:to_do/core/theme/theme_state.dart';
import 'package:to_do/core/locale/locale_bloc.dart';
import 'package:to_do/core/locale/locale_event.dart';
import 'package:to_do/core/locale/locale_state.dart';
import 'package:to_do/core/services/locale_service.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_event.dart';
import 'core/services/firestore_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(prefs)..add(const LoadThemeEvent()),
        ),
        BlocProvider<LocaleBloc>(
          create: (context) => LocaleBloc()..add(LoadSavedLocaleEvent()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            firestoreService: FirestoreService(),
          )..add(LoadTasksEvent()),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF121212),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, localeState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'TO-DO App',
                  routerConfig: AppRouter.router,
                  themeMode: themeState.themeMode,
                  theme: AppTheme.darkTheme(primaryColor: themeState.primaryColor),
                  locale: localeState.locale,
                  supportedLocales: LocaleService.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (context, child) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<TaskBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<ThemeBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<LocaleBloc>(),
                        ),
                      ],
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}