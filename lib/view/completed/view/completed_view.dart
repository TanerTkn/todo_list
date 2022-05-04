import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/view/home/controller/home_controller.dart';
import 'package:todo_list/widgets/dismissable_delete_task.dart';

class CompletedView extends StatefulWidget {
  const CompletedView({Key? key}) : super(key: key);

  @override
  State<CompletedView> createState() => _CompletedViewState();
}

class _CompletedViewState extends State<CompletedView> {
  HomeController controller = Get.put(HomeController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: _buildAppBar(context),
      body: StreamBuilder(
        stream: tasks.snapshots(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return const Center(
                child: StyledText(text: 'Bir hata oluştu. Tekrar deneyiniz.'));
          } else {
            if (asyncSnapshot.hasData) {
              List<DocumentSnapshot> completedTasks = asyncSnapshot.data.docs;
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
                        return listSnap[index]['completed']
                            ? Padding(
                                padding: context.paddingLow,
                                child: Dismissible(
                                  background: Container(),
                                  secondaryBackground:
                                      const DismissibleDeleteTask(),
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    completedTasks[index].reference.delete();
                                    Get.snackbar('Görev Başarıyla Kaldırıldı',
                                        '${completedTasks[index]['name']} Görevi kaldırdın.',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red,
                                        snackPosition: SnackPosition.BOTTOM,
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(EvaIcons.checkmarkCircle,
                                          color: Colors.green),
                                      SizedBox(
                                          width: context.dynamicWidth(0.03)),
                                      Flexible(
                                        child: Card(
                                          color: Colors.green,
                                          child: ListTile(
                                              title: StyledText(
                                                  text:
                                                      '${completedTasks[index]['name']}',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              leading: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    controller.iconBackground[
                                                        Random().nextInt(
                                                            controller
                                                                .iconBackground
                                                                .length)],
                                                    height: context
                                                        .dynamicHeight(0.05),
                                                  ),
                                                  SvgPicture.asset(
                                                    controller.icons[Random()
                                                        .nextInt(controller
                                                            .icons.length)],
                                                    height: context
                                                        .dynamicHeight(0.03),
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                              trailing: completedTaskDateInfo(
                                                  listSnap, index, context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Visibility(child: Text(''), visible: false);
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
      ),
    );
  }

  Column completedTaskDateInfo(List<DocumentSnapshot<Object?>> listSnap,
      int index, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StyledText(
          text: '${listSnap[index]['date']}',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // SizedBox(height: context.dynamicHeight(0.01)),
        // StyledText(
        //   text: '${listSnap[index]['time']}',
        //   color: Colors.white,
        //   fontWeight: FontWeight.bold,
        // ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorConstants.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          EvaIcons.arrowIosBackOutline,
          color: ColorConstants.textColor,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: StyledText.titleFontText(
          text: 'Tamamlanan Görevler',
          color: ColorConstants.textColor,
          fontWeight: FontWeight.bold),
    );
  }
}
