import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/constant/color_constant.dart';

class IconBottomBar extends StatelessWidget {
  final Icon icon;
  final bool selected;
  final Function() onPressed;
  const IconBottomBar(
      {Key? key,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
          color: selected ? ColorConstants.mainColor : ColorConstants.boxColor,
        )
      ],
    );
  }
}
