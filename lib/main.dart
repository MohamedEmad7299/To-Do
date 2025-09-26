
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/core/routing/AppRouter.dart';
import 'core/style/colors/app_colors.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.nearBlack,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.nearBlack,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark, // For iOS
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
