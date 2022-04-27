import 'package:flutter/material.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';

class HomeDataField extends StatelessWidget {
  const HomeDataField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const StyledText(
          text: '18 Nis',
          color: ColorConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: context.dynamicHeight(0.01)),
        const StyledText(
          text: '10:26',
          color: ColorConstants.textColor,
        ),
      ],
    );
  }
}
