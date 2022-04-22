import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';
import 'package:todo_list/widgets/task_delete.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = firestore.collection('tasks');
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: ColorConstants.background,
          body: TabBarView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: tasks.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return const Center(
                        child: StyledText(
                            text: 'Bir hata oluştu. Tekrar deneyiniz.'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listSnap = asyncSnapshot.data.docs;
                      return Padding(
                        padding: context.paddingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: context.dynamicHeight(0.05)),
                            const StyledText(
                              text: 'Hoşgeldin!',
                              color: ColorConstants.grey,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            const StyledText(
                              text: 'İşte Yapılacaklar Listen.',
                              color: ColorConstants.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            SizedBox(height: context.dynamicHeight(0.03)),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: listSnap.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: ColorConstants.orangeColor,
                                  child: ListTile(
                                    title: StyledText(
                                        text: '${listSnap[index]['taskName']}'),
                                    subtitle: StyledText(
                                        text:
                                            '${listSnap[index]['taskDescription']}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        width: context
                                                            .dynamicWidth(0.20),
                                                        height: context
                                                            .dynamicHeight(
                                                                0.30),
                                                        child: Form(
                                                          key: formKey,
                                                          child: Column(
                                                            children: [
                                                              TextField(
                                                                controller:
                                                                    taskName,
                                                                decoration:
                                                                    InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        labelText:
                                                                            'Görev Ekle'),
                                                              ),
                                                              SizedBox(
                                                                  height: context
                                                                      .dynamicHeight(
                                                                          0.05)),
                                                              TextField(
                                                                controller:
                                                                    taskDescription,
                                                                decoration:
                                                                    InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        labelText:
                                                                            'Görev Açıklaması'),
                                                              ),
                                                              SizedBox(
                                                                  height: context
                                                                      .dynamicHeight(
                                                                          0.03)),
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            ColorConstants.orangeColor)),
                                                                onPressed:
                                                                    () async {
                                                                  Map<String,
                                                                          dynamic>
                                                                      taskEdit =
                                                                      {
                                                                    'taskName':
                                                                        taskName,
                                                                    'taskDescription':
                                                                        taskDescription,
                                                                  };

                                                                  tasks
                                                                      .doc(taskName
                                                                          .text)
                                                                      .update(
                                                                          taskEdit)
                                                                      .whenComplete(
                                                                          () {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                'guncellendi');
                                                                  });
                                                                },
                                                                child:
                                                                    const StyledText(
                                                                  text:
                                                                      'Kaydet',
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              EvaIcons.editOutline,
                                              color: Colors.white,
                                            )),
                                        TaskDelete(
                                          listSnap: listSnap,
                                          index: index,
                                        ),
                                      ],
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
              const Center(
                child: StyledText(text: 'Done'),
              )
            ],
          ),

          //----------------------------- FLOAT ACTION BUTTON ----------------------------//

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton.extended(
            label: const StyledText(
              text: 'Yeni Görev',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            icon: const Icon(
              EvaIcons.plus,
              color: Colors.white,
            ),
            backgroundColor: ColorConstants.orangeColor,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: context.dynamicWidth(0.20),
                        height: context.dynamicHeight(0.30),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextField(
                                controller: taskName,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Görev Ekle'),
                              ),
                              SizedBox(height: context.dynamicHeight(0.05)),
                              TextField(
                                controller: taskDescription,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Görev Açıklaması'),
                              ),
                              SizedBox(height: context.dynamicHeight(0.03)),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorConstants.orangeColor)),
                                onPressed: () async {
                                  Map<String, dynamic> taskData = {
                                    'taskName': taskName.text,
                                    'taskDescription': taskDescription.text
                                  };
                                  await tasks.doc(taskName.text).set(taskData);
                                  setState(() {
                                    taskName.clear();
                                    taskDescription.clear();
                                  });
                                },
                                child: const StyledText(
                                  text: 'Kaydet',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),

          //----------------------------- BOTTOM APP BAR ----------------------------//

          bottomNavigationBar: bottomAppBar(),
        ));
  }

  BottomAppBar bottomAppBar() {
    return const BottomAppBar(
      child: TabBar(
        indicatorColor: ColorConstants.mainColor,
        tabs: [
          Tab(
            child: StyledText(
              text: 'Görevler',
              color: ColorConstants.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Tab(
            child: StyledText(
              text: 'Yapılanlar',
              color: ColorConstants.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
