
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/features/on_boarding/presentation/bloc/on_board_bloc.dart';
import 'package:to_do/features/on_boarding/presentation/widgets/onboarding_indicators.dart';
import 'package:to_do/features/on_boarding/presentation/widgets/onboarding_content.dart';
import 'package:to_do/features/on_boarding/presentation/widgets/onboarding_controls.dart';
import '../../core/routing/routes.dart';
import '../../core/style/colors/app_colors.dart';
import '../../core/style/text/app_texts.dart';
import 'data/onboarding_data.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: OnboardingData.pages.length),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
      previous.shouldNavigateToWelcome != current.shouldNavigateToWelcome,
      listener: (context, state) {
        if (state.shouldNavigateToWelcome) {
          context.replace(Routes.welcome);
        }
      },
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (previous, current) =>
        previous.currentPage != current.currentPage,
        listener: (context, state) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeInOut,
          );
        },
        child: Scaffold(
          backgroundColor: AppColors.nearBlack,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _SkipButton(
                    onSkip: () => context
                        .read<OnboardingBloc>()
                        .add(const OnboardingSkipPressed()),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: OnboardingContent(
                      pageController: _pageController,
                      pages: OnboardingData.pages,
                      onPageChanged: _onPageChanged,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OnboardingIndicators(
                    controller: _pageController,
                    count: OnboardingData.pages.length,
                  ),
                  const SizedBox(height: 48),
                  const OnboardingControls(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {

  final VoidCallback onSkip;

  const _SkipButton({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onSkip,
        child: Text(
          'SKIP',
          style: AppTextStyles.font16GrayW400,
        ),
      ),
    );
  }
}