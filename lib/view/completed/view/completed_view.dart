import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/view/completed/controller/completed_controller.dart';
import 'package:todo_list/widgets/dismissable_delete_task.dart';
import 'package:todo_list/widgets/home/home_date_field.dart';

class CompletedView extends StatefulWidget {
  const CompletedView({Key? key}) : super(key: key);

  @override
  State<CompletedView> createState() => _CompletedViewState();
}

class _CompletedViewState extends State<CompletedView> {
  CompletedController controller = Get.put(CompletedController());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: _buildAppBar(context),
      body: StreamBuilder(
        stream: controller.completedTasks(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return const Center(
                child: StyledText(text: 'Bir hata oluştu. Tekrar deneyiniz.'));
          } else {
            if (asyncSnapshot.hasData) {
              List<DocumentSnapshot> completedTasks = asyncSnapshot.data.docs;
              return Padding(
                padding: context.paddingMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.dynamicHeight(0.03)),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          return Padding(
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
                                  SizedBox(width: context.dynamicWidth(0.03)),
                                  Flexible(
                                    child: Card(
                                      color: Colors.white,
                                      child: ListTile(
                                          title: StyledText(
                                              text:
                                                  '${completedTasks[index]['name']}',
                                              color: ColorConstants.textColor),
                                          leading: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                controller.iconBackground[
                                                    Random().nextInt(controller
                                                        .iconBackground
                                                        .length)],
                                                height:
                                                    context.dynamicHeight(0.05),
                                              ),
                                              SvgPicture.asset(
                                                controller.icons[Random()
                                                    .nextInt(controller
                                                        .icons.length)],
                                                height:
                                                    context.dynamicHeight(0.03),
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          trailing: const HomeDataField()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
