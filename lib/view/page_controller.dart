import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/constant/color_constant.dart';
import 'package:todo_list/view/calendar/calendar_view.dart';
import 'package:todo_list/view/home/home_view.dart';
import 'package:todo_list/view/profile/profile_view.dart';
import 'package:todo_list/view/settings/settings_view.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/widgets/icon_bottombar.dart';

class PageController extends StatefulWidget {
  const PageController({Key? key}) : super(key: key);

  @override
  State<PageController> createState() => _PageControllerState();
}

class _PageControllerState extends State<PageController> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const CalendarView(),
      const ProfileView(),
      const SettingsView(),
    ];

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.mainColor,
        onPressed: () {
          setState(() {});
        },
        child: const Icon(
          EvaIcons.plus,
          color: ColorConstants.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: ColorConstants.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: context.dynamicHeight(0.10),
          child: Padding(
            padding: context.horizontalPaddingLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                    icon: Icon(EvaIcons.homeOutline),
                    selected: _selectedIndex == 0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }),
                IconBottomBar(
                    icon: Icon(EvaIcons.calendarOutline),
                    selected: _selectedIndex == 1,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }),
                IconBottomBar(
                    icon: Icon(EvaIcons.personOutline),
                    selected: _selectedIndex == 2,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    }),
                IconBottomBar(
                    icon: Icon(EvaIcons.settingsOutline),
                    selected: _selectedIndex == 3,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
