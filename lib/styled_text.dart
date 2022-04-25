import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? textOverFlow;

  const StyledText(
      {Key? key,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.textAlign,
      this.textOverFlow})
      : super(key: key);

  static titleFontText({
    required String text,
    Color? color,
    double? fontsize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return Text(
      text,
      style: GoogleFonts.getFont(
        fontFamily ?? "Baloo 2",
        color: color,
        fontSize: fontsize,
        fontWeight: fontWeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont(
        fontFamily ?? "Lato",
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
