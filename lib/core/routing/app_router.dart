
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
import '../../features/bottom_nav_pages/home/presentation/models/task_model.dart';
import '../../features/bottom_nav_pages/profile/presentation/profile_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/settings_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/change_account_name_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/change_password_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/change_account_image_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/about_us_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/faq_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/help_screen.dart';
import '../../features/bottom_nav_pages/profile/presentation/support_us_screen.dart';
import '../../features/bottom_nav_pages/tasks/presentation/task_details_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../services/auth_service.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => BlocProvider(
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
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(authService: AuthService()),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.forgetPassword,
        builder: (context, state) => BlocProvider(
          create: (context) => ResetPasswordBloc(authService: AuthService()),
          child: ResetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => HomeBloc(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterBloc(authService: AuthService()),
          child: RegisterScreen(),
        ),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => ProfilePage(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.taskDetails,
        builder: (context, state) {
          final task = state.extra as TaskModel;
          return TaskDetailsScreen(task: task);
        },
      ),
      GoRoute(
        path: Routes.changeAccountName,
        builder: (context, state) => const ChangeAccountNameScreen(),
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.changeAccountImage,
        builder: (context, state) => const ChangeAccountImageScreen(),
      ),
      GoRoute(
        path: Routes.aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: Routes.faq,
        builder: (context, state) => const FAQScreen(),
      ),
      GoRoute(
        path: Routes.help,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: Routes.support,
        builder: (context, state) => const SupportUsScreen(),
      ),
    ],
  );
}