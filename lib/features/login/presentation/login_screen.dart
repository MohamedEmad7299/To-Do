import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/features/login/presentation/bloc/login_bloc.dart';
import '../../../core/style/text/app_texts.dart';
import '../../../generated/assets.dart';
import '../finger_print/finger_print.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(CheckBiometricAvailability());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.hasValidated &&
            state.isValid &&
            !state.loginSuccess &&
            !state.isLoading) {
          context.read<LoginBloc>().add(LoginSubmitted());
        }

        if (state.loginSuccess) {
          context.replace(Routes.home);
        }

        if (state.loginError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.loginError!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.nearBlack,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 24),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "TO-DO",
                        style: AppTextStyles.font48LavenderPurpleW700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        "Username",
                        style: AppTextStyles.font16White400W,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (username) {
                          bloc.add(UsernameChanged(username));
                        },
                        style: AppTextStyles.font16White400W,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Enter your Username',
                          errorText: state.usernameError,
                          errorMaxLines: 2,
                          fillColor: AppColors.jetBlack,
                          filled: true,
                          suffixIcon: state.username.isNotEmpty
                              ? IconButton(
                            icon: Icon(
                              Icons.highlight_remove,
                              color: AppColors.lavenderPurple,
                            ),
                            onPressed: () {
                              _usernameController.clear();
                              bloc.add(ClearUser());
                            },
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.weakGray,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.weakGray,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.lavenderPurple,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        "Password",
                        style: AppTextStyles.font16White400W,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (password) {
                          bloc.add(PasswordChanged(password));
                        },
                        obscureText: !state.isPasswordVisible,
                        style: AppTextStyles.font16White400W,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          errorText: state.passwordError,
                          errorMaxLines: 2,
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_passwordController.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    color: AppColors.lavenderPurple,
                                  ),
                                  onPressed: () {
                                    _passwordController.clear();
                                    bloc.add(ClearPassword());
                                  },
                                ),
                              if (_passwordController.text.isNotEmpty)
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey.shade400,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              IconButton(
                                icon: Icon(
                                  state.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.lavenderPurple,
                                ),
                                onPressed: () {
                                  bloc.add(
                                    PasswordVisibilityChanged(
                                      state.isPasswordVisible,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          fillColor: AppColors.jetBlack,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.weakGray,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.weakGray,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: AppColors.lavenderPurple,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.push(Routes.forgetPassword);
                            },
                            child: Text(
                              "Forget Password ?",
                              style: AppTextStyles.font16GrayW400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                          (state.username.isEmpty || state.password.isEmpty)
                              ? null
                              : () {
                            bloc.add(ValidateFields());
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((
                                states,
                                ) {
                              if (states.contains(WidgetState.disabled)) {
                                return AppColors.weakGray;
                              }
                              return AppColors.lavenderPurple;
                            }),
                            shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: AppTextStyles.font16White400W,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(child: SvgPicture.asset(Assets.svgsOrDiv)),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement Google Sign In
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: AppColors.lavenderPurple,
                                width: 1,
                              ),
                            ),
                            shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.svgsGoogle,
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Login with Google',
                                style: AppTextStyles.font16White400W,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement [Facebook] Sign In
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: AppColors.lavenderPurple,
                                width: 1,
                              ),
                            ),
                            shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.svgsFacebook,
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Login with Facebook',
                                style: AppTextStyles.font16White400W,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Add FingerPrint widget here
                    if (state.biometricAvailable)
                      const Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                        ),
                        child: FingerPrint(),
                      ),
                    if (state.biometricAvailable)
                      const SizedBox(height: 24),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: AppTextStyles.font16GrayW400,
                            ),
                            TextSpan(
                              text: "Register",
                              style: AppTextStyles.font16White400W,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(Routes.register);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.lavenderPurple,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}