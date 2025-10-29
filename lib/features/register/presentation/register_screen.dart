
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared_widgets/app_text_field.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/validators/validator_helper.dart';
import 'package:to_do/features/register/presentation/bloc/register_bloc.dart';
import '../../../core/shared_widgets/app_button.dart';
import '../../../core/shared_widgets/app_logo.dart';
import '../../../core/shared_widgets/custom_back_button.dart';
import '../../../core/shared_widgets/loading_overlay.dart';
import '../../../core/shared_widgets/social_login_button.dart';
import '../../../core/shared_widgets/text_with_link.dart';
import '../../../generated/assets.dart';

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
          context.replace(Routes.home);
          bloc.add(RegisterReset());
        }

        if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          bloc.add(ClearRegisterError());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.nearBlack,
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
                      label: "Username",
                      controller: _usernameController,
                      validator: (value) =>
                          ValidatorHelper.validateUsername(value),
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter your username",
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<RegisterBloc, RegisterState>(
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
                          label: "Confirm Password",
                          controller: _confirmPasswordController,
                          hintText: "Repeat your password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
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
                                text: 'Register',
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
                        text: 'Register with Google',
                        onPressed: () {
                          // TODO: Implement Google Sign In
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
                        text: 'Register with Facebook',
                        onPressed: () {
                          // TODO: Implement Facebook Sign In
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextWithLink(
                        normalText: "Already have an account? ",
                        linkText: "Login",
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