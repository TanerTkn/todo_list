import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:todo_list/view/calendar/view/calendar_view.dart';
import 'package:todo_list/view/home/view/home_view.dart';
import 'package:todo_list/view/linear_gradient_color.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/widgets/bottom_bar.dart';

class PageControllerView extends StatefulWidget {
  const PageControllerView({Key? key}) : super(key: key);

  @override
  State<PageControllerView> createState() => _PageControllerViewState();
}

class _PageControllerViewState extends State<PageControllerView> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    final pages = [
      const HomeView(),
      const CalendarView(),
    ];
    final pageNames = ['Yapılacaklar', 'Takvim'];
    return Scaffold(
      backgroundColor: ColorConstants.background,
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.background,
        elevation: 0,
        title: StyledText.titleFontText(
          text: 'YAPILACAKLAR',
          color: ColorConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: context.paddingNormal,
            child: LinearGradientMask(
              color1: ColorConstants.pink,
              color2: ColorConstants.orange,
              child: SvgPicture.asset(
                SvgConstant.appBarIcon,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          pages[currentIndex],
          const BottomBar(),
        ],
      ),
    );
  }
}
