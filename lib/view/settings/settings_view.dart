import 'package:flutter/material.dart';
import 'package:todo_list/styled_text.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StyledText(text: "SETTINGS"),
    );
  }
}
