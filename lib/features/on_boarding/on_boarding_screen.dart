
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/features/on_boarding/presentation/bloc/on_board_bloc.dart';
import 'package:to_do/features/on_boarding/presentation/models/on_boarding_model.dart';
import 'package:to_do/features/on_boarding/presentation/widgets/on_boarding_page.dart';
import '../../core/routing/routes.dart';
import '../../generated/assets.dart';

class OnBoardingScreen extends StatelessWidget {

  final PageController boardController = PageController();

  final List<OnBoardingModel> boardings = [
    OnBoardingModel(
      image: Assets.svgsBoard1,
      title: 'Manage your tasks',
      description:
      'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnBoardingModel(
      image: Assets.svgsBoard2,
      title: 'Create daily routine',
      description:
      'In ToDo  you can create your personalized routine to stay productive',
    ),
    OnBoardingModel(
      image: Assets.svgsBoard3,
      title: 'Orgonaize your tasks',
      description:
      'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<OnBoardBloc,IndexState>(

      builder: (BuildContext context, state) {

        OnBoardBloc bloc = context.read<OnBoardBloc>();

        var currentIndex = state.index;

        return Scaffold(
          backgroundColor: AppColors.nearBlack,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32,),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.replace(Routes.welcome);
                      },
                      child: Text(
                        'SKIP',
                        style: GoogleFonts.lato(
                          color: AppColors.weakGray,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer()
                  ]
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) { bloc.add(UpdateIndex(index)); },
                    controller: boardController,
                    itemBuilder: (context, index) {
                      return OnBoardingPage(onBoardingModel: boardings[index]);
                    },
                    itemCount: boardings.length,
                  ),
                ),
                SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                  controller: boardController,
                  count: boardings.length,
                ),
                SizedBox(height: 72,),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        if (currentIndex > 0){
                          boardController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Text(
                        'BACK',
                        style: GoogleFonts.lato(
                          color: AppColors.weakGray,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (currentIndex == 2) {
                          context.replace(Routes.welcome);
                        } else {
                          boardController.nextPage(
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: AppColors.lavenderPurple,
                            borderRadius: BorderRadius.all(Radius.circular(4))
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 24),
                            Text(
                              currentIndex == 2 ? 'GET STARTED' : 'NEXT',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}