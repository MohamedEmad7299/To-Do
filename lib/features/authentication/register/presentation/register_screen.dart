
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared_widgets/app_text_field.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/utils/error_localizer.dart';
import 'package:to_do/core/validators/validator_helper.dart';
import 'package:to_do/l10n/app_localizations.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do/features/bottom_nav_pages/tasks/presentation/bloc/task_event.dart';
import '../../../../core/shared_widgets/app_button.dart';
import '../../../../core/shared_widgets/app_logo.dart';
import '../../../../core/shared_widgets/custom_back_button.dart';
import '../../../../core/shared_widgets/loading_overlay.dart';
import '../../../../core/shared_widgets/social_login_button.dart';
import '../../../../core/shared_widgets/text_with_link.dart';
import '../../../../generated/assets.dart';
import 'bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        if (state is RegisterSuccess) {
          context.read<TaskBloc>().add(LoadTasksEvent());
          context.go(Routes.home);
          bloc.add(RegisterReset());
        }

        if (state is RegisterError) {
          final localizedError = ErrorLocalizer.localizeError(context, state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizedError),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          bloc.add(ClearRegisterError());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    BlocBuilder<RegisterBloc, RegisterState>(
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
                          obscureText: !bloc.isPasswordVisible,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      buildWhen: (previous, current) =>
                      current is ConfirmPasswordVisible ||
                          current is ConfirmPasswordHidden,
                      builder: (context, state) {
                        return AppTextField(
                          label: AppLocalizations.of(context)!.confirmPassword,
                          controller: _confirmPasswordController,
                          hintText: AppLocalizations.of(context)!.repeatPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseConfirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return AppLocalizations.of(context)!.passwordsDoNotMatch;
                            }
                            return null;
                          },
                          isPassword: true,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !bloc.isConfirmPasswordVisible,
                        );
                      },
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
                          _confirmPasswordController,
                        ]),
                        builder: (context, _) {
                          return BlocBuilder<RegisterBloc, RegisterState>(
                            buildWhen: (previous, current) =>
                            current is RegisterLoading ||
                                current is RegisterErrorCleared ||
                                current is RegisterInitial,
                            builder: (context, state) {
                              final isLoading = state is RegisterLoading;
                              return AppButton(
                                text: AppLocalizations.of(context)!.registerButton,
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      !isLoading) {
                                    bloc.add(
                                      RegisterSubmitted(
                                        _usernameController.text,
                                        _passwordController.text,
                                        _confirmPasswordController.text,
                                      ),
                                    );
                                  }
                                },
                              );
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
                        text: AppLocalizations.of(context)!.registerWithGoogle,
                        onPressed: () {
                          bloc.add(GoogleSignUpRequested());
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
                        text: AppLocalizations.of(context)!.registerWithFacebook,
                        onPressed: () {
                         bloc.add(FacebookSignUpRequested());
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextWithLink(
                        normalText: AppLocalizations.of(context)!.alreadyHaveAccount,
                        linkText: AppLocalizations.of(context)!.loginButton,
                        onLinkTap: () => context.pop(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (previous, current) =>
              current is RegisterLoading ||
                  current is RegisterError ||
                  current is RegisterSuccess ||
                  current is RegisterErrorCleared ||
                  current is RegisterInitial,
              builder: (context, state) {
                return LoadingOverlay(isLoading: state is RegisterLoading);
              },
            ),
          ],
        ),
      ),
    );
  }
}