import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/styled_text.dart';

class TaskDelete extends StatelessWidget {
  const TaskDelete({
    Key? key,
    required this.listSnap,
    required this.index,
  }) : super(key: key);

  final List<DocumentSnapshot<Object?>> listSnap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const StyledText(text: 'Sil'),
                  content:
                      const StyledText(text: 'Silmek istediğine emin misin?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await listSnap[index].reference.delete();

                          Navigator.pop(context);
                        },
                        child: const StyledText(text: 'Sil')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const StyledText(text: 'İptal'))
                  ],
                );
              });
        },
        icon: const Icon(
          EvaIcons.trash2Outline,
          color: Colors.white,
        ));
  }
}
