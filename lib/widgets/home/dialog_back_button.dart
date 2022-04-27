import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/widgets/page_controller/title_text.dart';

class DialogBackButton extends StatelessWidget {
  const DialogBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            SvgConstant.addRectangleButton,
          ),
          const TitleTextFormField(
              color: Colors.white, text: 'GERİ', fontSize: 20),
        ],
      ),
    );
  }
}
