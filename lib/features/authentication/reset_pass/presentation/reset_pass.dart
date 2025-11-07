
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared_widgets/app_text_field.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/validators/validator_helper.dart';
import '../../../../core/shared_widgets/app_button.dart';
import '../../../../core/shared_widgets/app_logo.dart';
import '../../../../core/shared_widgets/custom_back_button.dart';
import '../../../../core/shared_widgets/loading_overlay.dart';
import 'bloc/reset_pass_bloc.dart';
import 'bloc/reset_pass_event.dart';
import 'bloc/reset_pass_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ResetPasswordBloc>();

    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (BuildContext context, ResetPasswordState state) {
        if (state is ResetPasswordSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link sent! Check your email.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back after short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.pop();
            }
          });

          bloc.add(ResetPasswordReset());
        }

        if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          bloc.add(ClearResetPasswordError());
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
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        'Enter your email address and we\'ll send you a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: "Email",
                      controller: _emailController,
                      validator: (value) =>
                          ValidatorHelper.validateEmailAddress(value),
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter your email",
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                        buildWhen: (previous, current) =>
                        current is ResetPasswordLoading ||
                            current is ResetPasswordErrorCleared ||
                            current is ResetPasswordInitial,
                        builder: (context, state) {
                          final isLoading = state is ResetPasswordLoading;
                          return AppButton(
                            text: 'Send Reset Link',
                            onPressed: isLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                bloc.add(
                                  ResetPasswordRequested(
                                    _emailController.text.trim(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              buildWhen: (previous, current) =>
              current is ResetPasswordLoading ||
                  current is ResetPasswordError ||
                  current is ResetPasswordSuccess ||
                  current is ResetPasswordErrorCleared ||
                  current is ResetPasswordInitial,
              builder: (context, state) {
                return LoadingOverlay(isLoading: state is ResetPasswordLoading);
              },
            ),
          ],
        ),
      ),
    );
  }
}