import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/features/on_boarding/presentation/models/on_boarding_model.dart';
import 'package:to_do/features/on_boarding/presentation/widgets/on_boarding_page.dart';

import '../../generated/assets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  var isLast = false;
  var currentIndex = 0;


  List<OnBoardingModel> boardings = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const SizedBox(width: 16,),
              TextButton(
                onPressed: () {},
                child: Text(
                  'SKIP',
                  style: GoogleFonts.lato(
                    color: AppColors.weakGray,
                    fontSize: 18,
                  ),
                ),
              ),
            ]
          ),
          Spacer(), // This pushes the button to the left
        ],
      ),
      backgroundColor: AppColors.nearBlack,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    physics: const BouncingScrollPhysics(), // Better scroll physics
                    onPageChanged: (index) {
                      currentIndex = index;
                      if (index == boardings.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    controller: boardController,
                    itemBuilder: (context, index) {
                      return OnBoardingPage(onBoardingModel: boardings[index]);
                    },
                    itemCount: boardings.length, // Use dynamic length
                  ),
                  // Centered indicator positioned above the content
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.50, // Adjust this value to position exactly where you want
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.white,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                        controller: boardController,
                        count: boardings.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                    if (isLast) {
                      // Handle navigation to next screen
                    } else {
                      boardController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
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
                          isLast ? 'GET STARTED' : 'NEXT',
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
  }
}