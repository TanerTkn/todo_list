import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/model/task_model.dart';
import 'package:todo_list/styled_text.dart';
import 'package:todo_list/view/calendar/controller/calendar_controller.dart';
import 'package:todo_list/widgets/calendar/color_utils.dart';
import 'package:todo_list/widgets/calendar/date_utils.dart' as date_util;
import 'package:kartal/kartal.dart';

import '../../../core/constant/color_constant.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController calendarController = Get.put(CalendarController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  TextEditingController controller = TextEditingController();

  List<Task> taskList = [];
  bool isLoadList = false;
  bool isLoadListEmpty = false;

  @override
  void initState() {
    _buildFetchTodoList(0, true);
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  Widget titleView() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: StyledText(
          text: date_util.DateUtils.months[currentDateTime.month - 1] +
              ' ' +
              currentDateTime.year.toString(),
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ));
  }

  Widget hrizontalCapsuleListView() {
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.18),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () async {
            await _buildFetchTodoList(index, false);
          },
          child: Container(
            width: context.dynamicWidth(0.22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: (currentMonthList[index].day != currentDateTime.day)
                      ? [
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.6)
                        ]
                      : [
                          HexColor("ED6184"),
                          HexColor("EF315B"),
                          HexColor("E2042D")
                        ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StyledText(
                      text: currentMonthList[index].day.toString(),
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? HexColor("465876")
                              : Colors.white),
                  StyledText(
                      text: date_util.DateUtils
                          .weekdays[currentMonthList[index].weekday - 1],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? HexColor("465876")
                              : Colors.white),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _buildFetchTodoList(int index, bool isFirstLoad) async {
    setState(() {
      isLoadList = false;
    });
    if (!isFirstLoad) {
      setState(() {
        currentDateTime = currentMonthList[index];
      });
    }

    taskList.clear();

    var formatter = DateFormat('dd/MM/yy');
    String formattedDate = formatter
        .format(isFirstLoad ? DateTime.now() : currentMonthList[index]);
    await FirebaseFirestore.instance
        .collection('tasks')
        .where('date', isEqualTo: formattedDate)
        .get()
        .then((s) {
      for (var i = 0; i < s.docs.length; i++) {
        setState(() {
          taskList.add(Task.fromJson(s.docs[i].data()));
        });
      }
      if (taskList.isEmpty) {
        setState(() {
          isLoadListEmpty = true;
          isLoadList = true;
        });
      } else {
        setState(() {
          isLoadListEmpty = false;

          isLoadList = true;
        });
      }
    });
  }

  Widget topView() {
    return Container(
      height: context.dynamicHeight(0.35),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              HexColor("488BC8").withOpacity(0.7),
              HexColor("488BC8").withOpacity(0.5),
              HexColor("488BC8").withOpacity(0.3)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(4, 4),
              spreadRadius: 2)
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');

    return Stack(
      children: [
        topView(),
        todoList(tasks),
      ],
    );
  }

  todoList(CollectionReference<Object?> tasks) {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.30)),
      child: Padding(
        padding: context.paddingNormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.dynamicHeight(0.03)),
            Flexible(
              child: !isLoadList
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : isLoadListEmpty
                      ? const Center(
                          child: Text('bu gune ait todo yok'),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: taskList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: context.verticalPaddingNormal,
                              child: Flexible(
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: StyledText(
                                        text: taskList[index].name,
                                        color: ColorConstants.textColor),
                                    leading: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          calendarController.iconBackground[
                                              taskList[index].selectedIconIndex],
                                          height: context.dynamicHeight(0.05),
                                        ),
                                        SvgPicture.asset(
                                          calendarController.icons[taskList[index].selectedIconIndex],
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
          ],
        ),
      ),
    );
  }
}
