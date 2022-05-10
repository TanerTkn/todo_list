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

class PageControllerView extends StatefulWidget {
  const PageControllerView({Key? key}) : super(key: key);

  @override
  State<PageControllerView> createState() => _PageControllerViewState();
}

class _PageControllerViewState extends State<PageControllerView> {
  PageViewController controller = Get.put(PageViewController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var now = DateTime.now();
  var formatter = DateFormat('dd/MM/yy');
  late String formattedDate;
  // DateTime? date = DateTime.now();
  int currentIndex = 0;
  final pages = [
    const HomeView(),
    const CalendarView(),
  ];
  final pageNames = ['Görevler', 'Takvim'];

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
                          int listLength = controller.isSelectedIcon.length;
                          controller.isSelectedIcon = [];
                          for (var i = 0; i < listLength; i++) {
                            controller.changeAllIconStatus();
                          }
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
    formattedDate = formatter.format(now);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
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
                            text: 'YENİ GÖREV EKLE', fontSize: 23),
                        SizedBox(height: context.dynamicHeight(0.02)),
                        const TitleTextFormField(
                            text: 'Simge Seçiniz', fontSize: 16),
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
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await _showDatePicker(context)
                                            .then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              // date = selectedDate;

                                              formattedDate = formatter
                                                  .format(selectedDate);
                                            });
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.add)),
                                  StyledText(text: (formattedDate))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.dynamicHeight(0.01)),
                        SizedBox(height: context.dynamicHeight(0.03)),
                        InkWell(
                          onTap: () async {
                            if (controller.isSelectedIcon.contains(true)) {
                              Map<String, dynamic> taskData = {
                                'name': controller.name.text,
                                'description': controller.description.text,
                                'date': formattedDate,
                                'completed': controller.completed.value,
                                'selectedIconIndex':
                                    controller.isSelectedIcon.indexOf(true)
                              };
                              await tasks.doc(randomString(10)).set(taskData);
                              setState(() {
                                controller.name.clear();
                                controller.description.clear();
                                formattedDate = '';
                              });
                              Navigator.pop(context);
                            } else {
                              Get.snackbar('hata', 'bir simge seciniz');
                            }
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
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: controller.isSelectedIcon.isEmpty
                          ? Colors.transparent
                          : controller.isSelectedIcon[index]
                              ? Colors.green
                              : Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isSelectedIcon[index]) {
                        controller.changeSelectedIconStatus(index, false);
                      } else {
                        int listLength = controller.isSelectedIcon.length;
                        controller.isSelectedIcon = [];
                        for (var i = 0; i < listLength; i++) {
                          controller.changeAllIconStatus();
                        }
                        controller.changeSelectedIconStatus(index, true);
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          controller.iconBackground[index],
                          height: context.dynamicHeight(0.05),
                        ),
                        SvgPicture.asset(
                          controller.icons[index],
                          height: context.dynamicHeight(0.03),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
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
