import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');
    return StreamBuilder<QuerySnapshot>(
      stream: tasks.snapshots(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return const Center(
              child: StyledText(text: 'Bir hata oluştu. Tekrar deneyiniz.'));
        } else {
          if (asyncSnapshot.hasData) {
            List<DocumentSnapshot> listSnap = asyncSnapshot.data.docs;
            return Padding(
              padding: context.paddingMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.dynamicHeight(0.03)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listSnap.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                            title: StyledText(
                                text: '${listSnap[index]['taskName']}',
                                color: ColorConstants.textColor),
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  iconBackground[index],
                                  height: context.dynamicHeight(0.05),
                                ),
                                SvgPicture.asset(
                                  icons[index],
                                  height: context.dynamicHeight(0.03),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const StyledText(
                                  text: '18 June',
                                  color: ColorConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: context.dynamicHeight(0.01)),
                                const StyledText(
                                  text: '10:26',
                                  color: ColorConstants.textColor,
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }
}
