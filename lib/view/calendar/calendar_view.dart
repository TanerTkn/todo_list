import 'package:flutter/material.dart';
import 'package:todo_list/styled_text.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StyledText(text: "CALENDAR"),
    );
  }
}
