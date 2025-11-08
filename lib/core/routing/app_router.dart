import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/features/authentication/reset_pass/presentation/bloc/reset_pass_bloc.dart';
import 'package:to_do/features/authentication/reset_pass/presentation/reset_pass.dart';
import 'package:to_do/features/on_boarding/onboarding_screen.dart';
import 'package:to_do/features/on_boarding/presentation/bloc/on_board_bloc.dart';
import 'package:to_do/features/welcome/presentation/welcome_screen.dart';
import '../../features/authentication/login/presentation/bloc/login_bloc.dart';
import '../../features/authentication/login/presentation/login_screen.dart';
import '../../features/authentication/register/presentation/bloc/register_bloc.dart';
import '../../features/authentication/register/presentation/register_screen.dart';
import '../../features/bottom_nav_pages/home/presentation/bloc/home_bloc.dart';
import '../../features/bottom_nav_pages/home/presentation/home_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/profile_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../fire_base/auth_service.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.onBoarding,
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
              create: (context) => OnboardingBloc(totalPages: 3),
              child: OnboardingScreen(),
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
              create: (context) => LoginBloc(authService: AuthService()),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        path: Routes.forgetPassword,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => ResetPasswordBloc(authService: AuthService()),
              child: ResetPasswordScreen(),
            ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => HomeBloc(),
              child: HomeScreen(),
            ),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) =>
            BlocProvider(
              create: (context) => RegisterBloc(authService: AuthService()),
              child: RegisterScreen(),
            ),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) =>
            ProfilePage(),
      ),
    ],
  );
}
