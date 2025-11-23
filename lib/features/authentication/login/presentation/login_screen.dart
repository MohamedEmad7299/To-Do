
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared_widgets/app_text_field.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/validators/validator_helper.dart';
import 'package:to_do/core/utils/error_localizer.dart';
import 'package:to_do/l10n/app_localizations.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_event.dart';
import '../../../../core/shared_widgets/app_button.dart';
import '../../../../core/shared_widgets/app_logo.dart';
import '../../../../core/shared_widgets/custom_back_button.dart';
import '../../../../core/shared_widgets/loading_overlay.dart';
import '../../../../core/shared_widgets/social_login_button.dart';
import '../../../../core/shared_widgets/text_with_link.dart';
import '../../../../core/style/text/app_texts.dart';
import '../../../../generated/assets.dart';
import '../finger_print/finger_print.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccessState) {
          context.read<TaskBloc>().add(LoadTasksEvent());
          context.replace(Routes.home);
          context.read<LoginBloc>().add(LoginReset());
        }

        if (state is LoginErrorState) {
          final localizedError = ErrorLocalizer.localizeError(context, state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizedError),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );

          context.read<LoginBloc>().add(ClearLoginError());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    const CustomBackButton(),
                    const SizedBox(height: 16),
                    const AppLogo(),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: AppLocalizations.of(context)!.email,
                      controller: _usernameController,
                      validator: (value) =>
                          ValidatorHelper.validateEmailAddress(value),
                      keyboardType: TextInputType.emailAddress,
                      hintText: AppLocalizations.of(context)!.enterUsername,
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                      current is PasswordVisible ||
                          current is PasswordHidden,
                      builder: (context, state) {
                        return AppTextField(
                          label: AppLocalizations.of(context)!.password,
                          controller: _passwordController,
                          hintText: AppLocalizations.of(context)!.enterPassword,
                          validator: (value) =>
                              ValidatorHelper.validatePassword(value),
                          isPassword: true,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !loginBloc.isPasswordVisible,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.push(Routes.forgetPassword),
                            child: Text(
                              AppLocalizations.of(context)!.forgetPassword,
                              style: AppTextStyles.font16GrayW400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: ListenableBuilder(
                        listenable: Listenable.merge([
                          _usernameController,
                          _passwordController,
                        ]),
                        builder: (context, _) {
                          return AppButton(
                            text: AppLocalizations.of(context)!.loginButton,
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  !loginBloc.isLoading) {
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    _usernameController.text,
                                    _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(child: SvgPicture.asset(Assets.svgsOrDiv)),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: SocialLoginButton(
                        iconAsset: Assets.svgsGoogle,
                        text: AppLocalizations.of(context)!.loginWithGoogle,
                        onPressed: () {
                          // CHANGE: Trigger Google Sign In
                          loginBloc.add(GoogleSignInRequested());
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: SocialLoginButton(
                        iconAsset: Assets.svgsFacebook,
                        text: AppLocalizations.of(context)!.loginWithFacebook,
                        onPressed: () {
                          // CHANGE: Trigger Facebook Sign In
                          loginBloc.add(FacebookSignInRequested());
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                      current is BiometricAvailable ||
                          current is BiometricNotAvailable,
                      builder: (context, state) {
                        if (loginBloc.biometricAvailable && loginBloc.biometricEnabled) {
                          return const Center(
                            child: FingerPrint(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                      current is BiometricAvailable ||
                          current is BiometricNotAvailable,
                      builder: (context, state) {
                        if (loginBloc.biometricAvailable) {
                          return const SizedBox(height: 16);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Center(
                      child: TextWithLink(
                        normalText: AppLocalizations.of(context)!.dontHaveAccount,
                        linkText: AppLocalizations.of(context)!.register,
                        onLinkTap: () => context.push(Routes.register),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
              current is LoginLoading || current is LoginNotLoading,
              builder: (context, state) {
                return LoadingOverlay(isLoading: loginBloc.isLoading);
              },
            ),
          ],
        ),
      ),
    );
  }
}