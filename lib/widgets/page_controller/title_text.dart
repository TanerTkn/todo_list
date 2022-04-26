import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/core/constant/color_constant.dart';

class TitleTextFormField extends StatelessWidget {
  final String text;
  final double fontSize;
  final String? fontFamily;

  const TitleTextFormField({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont(
        fontFamily ?? "Baloo 2",
        color: ColorConstants.textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
