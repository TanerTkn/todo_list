import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/view/calendar/view/calendar_view.dart';
import 'package:todo_list/view/home/view/home_view.dart';

class PageViewController extends GetxController {
  TextStyle titleStyle = GoogleFonts.getFont(
    "Baloo 2",
    color: ColorConstants.textColor,
    fontWeight: FontWeight.bold,
  );
  TextStyle textStyle = GoogleFonts.getFont(
    "Lato",
    color: ColorConstants.textColor,
    fontWeight: FontWeight.bold,
  );

  List iconBackground = [
    SvgConstant.orangeCircularIcon,
    SvgConstant.deepBlueCircularIcon,
    SvgConstant.lightBlueCircularIcon,
    SvgConstant.pinkblueCircularIcon,
  ];
  List icons = [
    SvgConstant.weight,
    SvgConstant.coding,
    SvgConstant.console,
    SvgConstant.coding,
  ];

  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final time = TextEditingController().obs;
  DateTime currentDate = DateTime.now();

  RxBool completed = false.obs;

  final pages = [
    const HomeView(),
    const CalendarView(),
  ];
  final pageNames = ['Yapılacaklar', 'Takvim'];
}
