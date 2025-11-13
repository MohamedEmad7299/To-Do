
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared_widgets/app_text_field.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/validators/validator_helper.dart';
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
          context.replace(Routes.home);
          context.read<LoginBloc>().add(LoginReset());
        }

        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
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
                      label: "Username",
                      controller: _usernameController,
                      validator: (value) =>
                          ValidatorHelper.validateEmailAddress(value),
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter your username",
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                      current is PasswordVisible ||
                          current is PasswordHidden,
                      builder: (context, state) {
                        return AppTextField(
                          label: "Password",
                          controller: _passwordController,
                          hintText: "Enter your password",
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
                              "Forget Password ?",
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
                            text: 'Login',
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
                        text: 'Login with Google',
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
                        text: 'Login with Facebook',
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
                        normalText: "Don't have an account? ",
                        linkText: "Register",
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