import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/style/colors/app_colors.dart';
import '../presentation/bloc/login_bloc.dart';

class FingerPrint extends StatelessWidget {
  const FingerPrint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();

        return InkWell(
          onTap: state.isLoading || !state.biometricAvailable
              ? null
              : () {
            bloc.add(BiometricAuthenticationRequested());
          },
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: state.biometricAvailable
                    ? AppColors.lavenderPurple[0]
                    : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: state.biometricAvailable
                      ? AppColors.lavenderPurple
                      : Colors.grey,
                ),
              ),
              child: state.isLoading
                  ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.lavenderPurple,
                  ),
                ),
              )
                  : Icon(
                Icons.fingerprint,
                size: 32,
                color: state.biometricAvailable
                    ? AppColors.lavenderPurple
                    : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}