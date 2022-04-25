import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:kartal/kartal.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BottomAppBar(
        elevation: 0,
        color: ColorConstants.background,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: context.dynamicHeight(0.12),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  focusColor: ColorConstants.background,
                  splashColor: ColorConstants.background,
                  hoverColor: ColorConstants.background,
                  highlightColor: ColorConstants.background,
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(SvgConstant.pinkCircularButton,
                          height: context.dynamicHeight(0.10)),
                      SvgPicture.asset(SvgConstant.check,
                          height: context.dynamicHeight(0.02)),
                    ],
                  ),
                ),
                InkWell(
                  focusColor: ColorConstants.background,
                  splashColor: ColorConstants.background,
                  hoverColor: ColorConstants.background,
                  highlightColor: ColorConstants.background,
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(SvgConstant.whiteCircularButton,
                          height: context.dynamicHeight(0.12)),
                      SvgPicture.asset(SvgConstant.calendar,
                          height: context.dynamicHeight(0.045)),
                    ],
                  ),
                ),
                InkWell(
                  focusColor: ColorConstants.background,
                  splashColor: ColorConstants.background,
                  hoverColor: ColorConstants.background,
                  highlightColor: ColorConstants.background,
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgConstant.blueCircularButton,
                        height: context.dynamicHeight(0.10),
                      ),
                      SvgPicture.asset(SvgConstant.plus,
                          height: context.dynamicHeight(0.02)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
