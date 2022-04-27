import 'package:flutter/material.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';

class DismissibleDeleteTask extends StatelessWidget {
  const DismissibleDeleteTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(right: context.dynamicWidth(0.05)),
            child: StyledText.titleFontText(
              text: 'KALDIR',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontsize: 25,
            )),
      ),
      color: Colors.red,
    );
  }
}
