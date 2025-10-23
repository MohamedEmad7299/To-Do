
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/features/forget_password/presentation/forget_password.dart';
import 'package:to_do/features/home/presentation/home_screen.dart';
import 'package:to_do/features/login/presentation/bloc/login_bloc.dart';
import 'package:to_do/features/login/presentation/login_screen.dart';
import 'package:to_do/features/on_boarding/on_boarding_screen.dart';
import 'package:to_do/features/on_boarding/presentation/bloc/on_board_bloc.dart';
import 'package:to_do/features/register/presentation/register.dart';
import 'package:to_do/features/welcome/presentation/welcome_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) =>
        const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => OnBoardBloc(),
              child: OnBoardingScreen(),
            ),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        path: Routes.forgetPassword,
        builder: (context, state) =>
            ForgetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) =>
            HomeScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) =>
            RegisterScreen(),
      ),
    ],
  );
}
