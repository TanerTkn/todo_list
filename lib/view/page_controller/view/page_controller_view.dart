import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:todo_list/view/calendar/view/calendar_view.dart';
import 'package:todo_list/view/completed/view/completed_view.dart';
import 'package:todo_list/view/home/view/home_view.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/view/page_controller/controller/page_controller.dart';
import 'package:todo_list/widgets/page_controller/custom_bottom_bar.dart';
import 'package:todo_list/widgets/page_controller/title_text.dart';
import 'dart:math' show Random;

class PageControllerView extends StatefulWidget {
  const PageControllerView({Key? key}) : super(key: key);

  @override
  State<PageControllerView> createState() => _PageControllerViewState();
}

class _PageControllerViewState extends State<PageControllerView> {
  PageViewController controller = Get.put(PageViewController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int currentIndex = 0;
  final pages = [
    const HomeView(),
    const CalendarView(),
  ];
  final pageNames = ['Yapılacaklar', 'Takvim'];

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');

    return Scaffold(
      backgroundColor: ColorConstants.background,
      extendBody: true,
      appBar: _buildAppBar(pageNames, currentIndex, context),
      body: Stack(
        children: [
          pages[currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              elevation: 0,
              color: ColorConstants.background,
              shape: const CircularNotchedRectangle(),
              child: SizedBox(
                height: context.dynamicHeight(0.12),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBottomBar(
                        svgIcon: SvgConstant.check,
                        buttonHeight: context.dynamicHeight(0.10),
                        svgButton: SvgConstant.pinkCircularButton,
                        iconHeight: context.dynamicHeight(0.02),
                        onTap: () {
                          Get.to(const CompletedView());
                        },
                      ),
                      CustomBottomBar(
                        svgIcon: currentIndex == 0
                            ? SvgConstant.calendar
                            : SvgConstant.listBottomIcon,
                        buttonHeight: context.dynamicHeight(0.12),
                        svgButton: SvgConstant.whiteCircularButton,
                        iconHeight: context.dynamicHeight(0.045),
                        onTap: () {
                          if (currentIndex == 0) {
                            setState(() {
                              currentIndex = 1;
                            });
                          } else {
                            setState(() {
                              currentIndex = 0;
                            });
                          }
                        },
                      ),
                      CustomBottomBar(
                        svgIcon: SvgConstant.plus,
                        buttonHeight: context.dynamicHeight(0.10),
                        svgButton: SvgConstant.blueCircularButton,
                        iconHeight: context.dynamicHeight(0.02),
                        onTap: () async {
                          await _addTaskFunction(context, tasks);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addTaskFunction(
      BuildContext context, CollectionReference<Object?> tasks) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
                height: context.dynamicHeight(0.95),
                width: double.infinity,
                child: Padding(
                  padding: context.paddingMedium,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.dynamicHeight(0.01)),
                      const TitleTextFormField(
                          text: 'YENİ YAPILACAK EKLE', fontSize: 23),
                      SizedBox(height: context.dynamicHeight(0.02)),
                      const TitleTextFormField(text: 'Simge', fontSize: 16),
                      _buildTaskListViewBuilder(context),
                      SizedBox(height: context.dynamicHeight(0.01)),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              style: controller.textStyle,
                              controller: controller.name,
                              decoration: InputDecoration(
                                  labelStyle: controller.titleStyle,
                                  border: const UnderlineInputBorder(),
                                  labelText: 'Başlık'),
                            ),
                            SizedBox(height: context.dynamicHeight(0.03)),
                            const TitleTextFormField(
                                text: 'Açıklama', fontSize: 16),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            TextField(
                              style: controller.textStyle,
                              maxLines: 5,
                              controller: controller.description,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            const TitleTextFormField(
                                text: 'Tarih', fontSize: 16),
                            SizedBox(height: context.dynamicHeight(0.02)),
                            TextFormField(
                              style: GoogleFonts.getFont("Lato",
                                  color: ColorConstants.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              readOnly: true,
                              controller: controller.date,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.date_range,
                                  color: ColorConstants.textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 42, vertical: 20),
                              ),
                              onTap: () async {
                                await _showDatePicker(context)
                                    .then((selectedDate) {
                                  if (selectedDate != null) {
                                    controller.date.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(selectedDate);
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter date.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.dynamicHeight(0.01)),
                      const TitleTextFormField(text: 'Saat', fontSize: 16),
                      SizedBox(height: context.dynamicHeight(0.01)),
                      Obx(
                        () => TextFormField(
                          style: GoogleFonts.getFont("Lato",
                              color: ColorConstants.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          readOnly: true,
                          controller: controller.time.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.access_time_sharp,
                              color: ColorConstants.textColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                          ),
                          onTap: () async {
                            final TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: controller.selectedTime,
                              initialEntryMode: TimePickerEntryMode.dial,
                            );
                            if (timeOfDay != controller.selectedTime) {
                              setState(() {
                                controller.selectedTime = timeOfDay!;
                                controller.time.value = TextEditingController(
                                    text: timeOfDay.format(context));
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: context.dynamicHeight(0.03)),
                      InkWell(
                        onTap: () async {
                          Map<String, dynamic> taskData = {
                            'name': controller.name.text,
                            'description': controller.description.text,
                            'date': controller.date.text,
                            'time': controller.time.value.text,
                            'completed': controller.completed.value,
                          };
                          await tasks.doc(randomString(10)).set(taskData);
                          setState(() {
                            controller.name.clear();
                            controller.description.clear();
                            controller.date.clear();
                            controller.time.value.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgConstant.addRectangleButton,
                            ),
                            const TitleTextFormField(
                                color: Colors.white,
                                text: 'EKLE',
                                fontSize: 18),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
              dialogBackgroundColor: ColorConstants.background,
              colorScheme: const ColorScheme.light(
                primary: ColorConstants.textColor,
                onPrimary: Colors.white,
                onSurface: ColorConstants.orange,
              ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                textStyle:
                    GoogleFonts.getFont("Lato", fontWeight: FontWeight.bold),
                primary: ColorConstants.textColor,
              ))),
          child: child!),
    );
  }

  Flexible _buildTaskListViewBuilder(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: context.dynamicHeight(0.06),
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.icons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: context.paddingLow,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    controller.iconBackground[
                        Random().nextInt(controller.iconBackground.length)],
                    height: context.dynamicHeight(0.05),
                  ),
                  SvgPicture.asset(
                    controller.icons[Random().nextInt(controller.icons.length)],
                    height: context.dynamicHeight(0.03),
                    color: Colors.white,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      List<String> pageNames, int currentIndex, BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorConstants.background,
      elevation: 0,
      title: StyledText.titleFontText(
        text: pageNames[currentIndex],
        color: ColorConstants.textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
