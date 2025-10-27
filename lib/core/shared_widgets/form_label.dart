
import 'package:flutter/material.dart';
import '../style/text/app_texts.dart';

class FormLabel extends StatelessWidget {

  final String text;

  const FormLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.font16White400W,
    );
  }
}