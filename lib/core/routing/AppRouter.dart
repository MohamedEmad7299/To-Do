
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/features/on_boarding/on_boarding_screen.dart';
import 'package:to_do/features/splash/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.onBoarding,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
    ],
  );
}
