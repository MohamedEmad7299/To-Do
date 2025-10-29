import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/style/colors/app_colors.dart';
import '../presentation/bloc/login_bloc.dart';

class FingerPrint extends StatelessWidget {
  const FingerPrint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
      current is BiometricAvailable || current is BiometricNotAvailable,
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        final biometricAvailable = bloc.biometricAvailable;

        return SizedBox(
          width: 60,
          height: 60,
          child: InkWell(
            onTap: !biometricAvailable
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
                  color: biometricAvailable
                      ? AppColors.lavenderPurple[0]
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: biometricAvailable
                        ? AppColors.lavenderPurple
                        : Colors.grey,
                  ),
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 32,
                  color: biometricAvailable
                      ? AppColors.lavenderPurple
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}