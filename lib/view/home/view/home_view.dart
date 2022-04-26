import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/view/home/controller/home_controller.dart';
import 'package:todo_list/widgets/home/home_date_field.dart';

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
                            background: Card(
                              color: Colors.green,
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
                            secondaryBackground: Card(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        right: context.dynamicWidth(0.05)),
                                    child: StyledText.titleFontText(
                                      text: 'KALDIR',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 25,
                                    )),
                              ),
                              color: Colors.red,
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                Get.snackbar(
                                    'Görevi Başarıyla Tamamlandılara Ekledin',
                                    '${listSnap[index]['taskName']} Görev tamamlandı.',
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
                                    '${listSnap[index]['taskName']} Görevi kaldırdın.',
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
                                  title: StyledText(
                                      text: '${listSnap[index]['taskName']}',
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
                                  trailing: const HomeDataField()),
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
}
