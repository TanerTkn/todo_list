import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/core/constant/color_constant.dart';
import 'package:todo_list/styled_text.dart';
import 'package:kartal/kartal.dart';

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
                      return ListView.builder(
                        itemCount: listSnap.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: StyledText(
                                  text: '${listSnap[index]['taskName']}'),
                              subtitle: StyledText(
                                  text:
                                      '${listSnap[index]['taskDescription']}'),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title:
                                                const StyledText(text: 'Sil'),
                                            content: const StyledText(
                                                text:
                                                    'Silmek istediğine emin misin?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await listSnap[index]
                                                        .reference
                                                        .delete();

                                                    Navigator.pop(context);
                                                  },
                                                  child: const StyledText(
                                                      text: 'Sil')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const StyledText(
                                                      text: 'İptal'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    EvaIcons.trash2Outline,
                                    color: Colors.red,
                                  )),
                            ),
                          );
                        },
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
          floatingActionButton: FloatingActionButton(
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
                              ElevatedButton(
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
                                  color: ColorConstants.white,
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
            child: const Icon(
              EvaIcons.plus,
              color: ColorConstants.white,
            ),
          ),
          bottomNavigationBar: bottomAppBar(),
        ));
  }

  BottomAppBar bottomAppBar() {
    return const BottomAppBar(
      child: TabBar(
        tabs: [
          Tab(
            child: StyledText(
              text: 'Görevler',
              color: ColorConstants.titleColor,
            ),
          ),
          Tab(
            child: StyledText(
              text: 'Yapılanlar',
              color: ColorConstants.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
