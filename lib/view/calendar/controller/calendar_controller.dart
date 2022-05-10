import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_list/core/constant/svg_constant.dart';

class CalendarController extends GetxController {
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
  ];
  final formKey = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
}
