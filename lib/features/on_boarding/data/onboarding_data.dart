

import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';
import '../../../generated/assets.dart';
import '../presentation/models/on_boarding_model.dart';

class OnboardingData {
  static List<OnboardingPageModel> getPages(BuildContext context) {
    return [
      OnboardingPageModel(
        image: Assets.svgsBoard1,
        title: AppLocalizations.of(context)!.onboarding1Title,
        description: AppLocalizations.of(context)!.onboarding1Description,
      ),
      OnboardingPageModel(
        image: Assets.svgsBoard2,
        title: AppLocalizations.of(context)!.onboarding2Title,
        description: AppLocalizations.of(context)!.onboarding2Description,
      ),
      OnboardingPageModel(
        image: Assets.svgsBoard3,
        title: AppLocalizations.of(context)!.onboarding3Title,
        description: AppLocalizations.of(context)!.onboarding3Description,
      ),
    ];
  }
}