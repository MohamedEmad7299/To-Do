

import '../../../generated/assets.dart';
import '../presentation/models/on_boarding_model.dart';

class OnboardingData {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      image: Assets.svgsBoard1,
      title: 'Manage your tasks',
      description: 'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnboardingPageModel(
      image: Assets.svgsBoard2,
      title: 'Create daily routine',
      description: 'In ToDo you can create your personalized routine to stay productive',
    ),
    OnboardingPageModel(
      image: Assets.svgsBoard3,
      title: 'Organize your tasks',
      description: 'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];
}