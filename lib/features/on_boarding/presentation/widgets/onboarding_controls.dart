
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/on_boarding/presentation/bloc/on_board_bloc.dart';

import '../../../../core/style/colors/app_colors.dart';
import '../../../../core/style/text/app_texts.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final bloc = context.read<OnboardingBloc>();

        return Row(
          children: [
            _BackButton(
              onPressed: state.isFirstPage
                  ? null
                  : () => bloc.add(const OnboardingBackPressed()),
            ),
            const Spacer(),
            _NextButton(
              isLastPage: state.isLastPage,
              onPressed: () => bloc.add(const OnboardingNextPressed()),
            ),
          ],
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _BackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'BACK',
        style: AppTextStyles.font16GrayW400.copyWith(
          color: onPressed == null ? Colors.grey.withValues(alpha: 0.3) : null,
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const _NextButton({
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lavenderPurple,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(
              isLastPage ? 'GET STARTED' : 'NEXT',
              style: AppTextStyles.font16White400W,
            ),
          ),
        ),
      ),
    );
  }
}