import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(text: DateFormat('yMMMMd', 'tr').format(DateTime.now())),
            SizedBox(height: context.dynamicHeight(0.02)),
            const StyledText(
              text: "Bugün'ün Planı",
              color: ColorConstants.titleColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: context.dynamicHeight(0.02)),
            Card(
              child: ListTile(
                title: const StyledText(
                  text: "Flutter",
                  color: ColorConstants.textColor,
                  fontWeight: FontWeight.bold,
                ),
                leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_box_outline_blank,
                      color: ColorConstants.mainColor,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
