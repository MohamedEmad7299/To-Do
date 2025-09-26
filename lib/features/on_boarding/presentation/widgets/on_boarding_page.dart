import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/on_boarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel onBoardingModel;

  const OnBoardingPage({super.key, required this.onBoardingModel});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: SvgPicture.asset(
                onBoardingModel.image,
                width: 271,
                height: 296,
                placeholderBuilder: (BuildContext context) => Container(
                  width: 271,
                  height: 296,
                  color: Colors.grey.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 128),
            Text(
              onBoardingModel.title,
              style: _titleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              onBoardingModel.description,
              style: _descriptionTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static final TextStyle _titleTextStyle = GoogleFonts.lato(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle _descriptionTextStyle = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.white.withOpacity(0.8),
    height: 1.4, // Better line height for readability
  );
}