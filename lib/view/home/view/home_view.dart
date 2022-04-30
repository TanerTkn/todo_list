import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/view/home/controller/home_controller.dart';
import 'package:todo_list/widgets/dismissable_delete_task.dart';
import 'package:todo_list/widgets/home/dialog_back_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
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
                        return Padding(
                          padding: context.paddingLow,
                          child: Dismissible(
                            background: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  gradient: LinearGradient(colors: [
                                    ColorConstants.orange,
                                    ColorConstants.pink
                                  ])),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: context.dynamicWidth(0.05)),
                                    child: StyledText.titleFontText(
                                      text: 'TAMAMLANDI',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 25,
                                    )),
                              ),
                            ),
                            secondaryBackground: const DismissibleDeleteTask(),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                Get.snackbar(
                                    'Görevi Başarıyla Tamamlandılara Ekledin',
                                    '${listSnap[index]['name']} Görev tamamlandı.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.green,
                                    snackPosition: SnackPosition.BOTTOM,
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ));
                              } else {
                                listSnap[index].reference.delete();
                                Get.snackbar('Görev Başarıyla Kaldırıldı',
                                    '${listSnap[index]['name']} Görevi kaldırdın.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    snackPosition: SnackPosition.BOTTOM,
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white));
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                  onTap: () {
                                    _showTaskDetailDialog(
                                        context, index, listSnap);
                                  },
                                  title: StyledText(
                                      text: '${listSnap[index]['name']}',
                                      color: ColorConstants.textColor),
                                  leading: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        controller.iconBackground[Random()
                                            .nextInt(controller
                                                .iconBackground.length)],
                                        height: context.dynamicHeight(0.05),
                                      ),
                                      SvgPicture.asset(
                                        controller.icons[Random()
                                            .nextInt(controller.icons.length)],
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
                                      StyledText(
                                        text: '${listSnap[index]['date']}',
                                        color: ColorConstants.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                          height: context.dynamicHeight(0.01)),
                                      StyledText(
                                        text: '${listSnap[index]['time']}',
                                        color: ColorConstants.textColor,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
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
      ),
    );
  }

  Future<dynamic> _showTaskDetailDialog(BuildContext context, int index,
      List<DocumentSnapshot<Object?>> listSnap) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: context.paddingMedium,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: context.paddingLow,
                  width: double.infinity,
                  height: context.dynamicHeight(0.50),
                  child: Column(
                    children: [
                      _sizedBox03(context),
                      _taskIcon(index, context),
                      _sizedBox03(context),
                      _taskName(listSnap, index),
                      _sizedBox03(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _taskDate(listSnap, index),
                          _sizedBoxWidth03(context),
                          _taskTime(listSnap, index),
                        ],
                      ),
                      _sizedBox05(context),
                      _taskSubtitle(),
                      _sizedBox03(context),
                      _taskDescription(listSnap, index),
                      const Spacer(),
                      const DialogBackButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Stack _taskIcon(int index, BuildContext context) {
    return Stack(
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
    );
  }

  StyledText _taskName(List<DocumentSnapshot<Object?>> listSnap, int index) {
    return StyledText(
        text: '${listSnap[index]['name']}',
        color: ColorConstants.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold);
  }

  StyledText _taskDate(List<DocumentSnapshot<Object?>> listSnap, int index) {
    return StyledText(
      text: '${listSnap[index]['date']}',
      color: ColorConstants.textColor,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
  }

  StyledText _taskTime(List<DocumentSnapshot<Object?>> listSnap, int index) {
    return StyledText(
      text: '${listSnap[index]['time']}',
      color: ColorConstants.textColor,
      fontSize: 17,
    );
  }

  StyledText _taskSubtitle() {
    return const StyledText(
      text: 'Açıklama',
      color: ColorConstants.textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  StyledText _taskDescription(
      List<DocumentSnapshot<Object?>> listSnap, int index) {
    return StyledText(
      text: '${listSnap[index]['description']}',
      color: ColorConstants.textColor,
    );
  }

  SizedBox _sizedBox05(BuildContext context) {
    return SizedBox(height: context.dynamicHeight(0.05));
  }

  SizedBox _sizedBox03(BuildContext context) {
    return SizedBox(height: context.dynamicHeight(0.03));
  }

  SizedBox _sizedBoxWidth03(BuildContext context) {
    return SizedBox(width: context.dynamicWidth(0.03));
  }
}
