
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/app_colors.dart';

class AppTextStyles {

  static final TextStyle font32White700W = GoogleFonts.lato(
    fontSize: 32,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle font16White400W = GoogleFonts.lato(
    fontSize: 16,
    color: Color(0xDEFFFFFF),
    fontWeight: FontWeight.w400,
  );

  static final TextStyle font16GrayW400 = GoogleFonts.lato(
    fontSize: 16,
    color: AppColors.ashGray,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle font48LavenderPurpleW700 = GoogleFonts.lato(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.lavenderPurple,
  );

  static final TextStyle font32LavenderPurpleW500 = GoogleFonts.lato(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.lavenderPurple,
  );

  static final TextStyle font12White = GoogleFonts.lato(
    fontSize: 12,
    color: Colors.white
  );

  static final TextStyle font20White = GoogleFonts.lato(
      fontSize: 20,
      color: Colors.white
  );

  static final TextStyle font16White = GoogleFonts.lato(
      fontSize: 16,
      color: Colors.white
  );
}