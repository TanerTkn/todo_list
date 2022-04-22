import 'package:flutter/material.dart';
import 'package:todo_list/styled_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StyledText(text: "PROFILE"),
    );
  }
}
