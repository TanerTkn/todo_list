import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list/core/constant/color_constant.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    Key? key,
    required this.svgIcon,
    required this.svgButton,
    required this.buttonHeight,
    required this.iconHeight,
    required this.onTap,
  }) : super(key: key);

  final String svgButton;
  final String svgIcon;
  final double buttonHeight;
  final double iconHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color colorBackground = ColorConstants.background;
    return InkWell(
      focusColor: colorBackground,
      splashColor: colorBackground,
      hoverColor: colorBackground,
      highlightColor: colorBackground,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(svgButton, height: buttonHeight),
          SvgPicture.asset(svgIcon, height: iconHeight),
        ],
      ),
    );
  }
}
