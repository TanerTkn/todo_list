// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_list/styled_text.dart';
// import 'package:kartal/kartal.dart';

// class TaskUpgrade extends StatelessWidget {
//   const TaskUpgrade({
//     Key? key,
//     required this.listSnap,
//     required this.index,
//   }) : super(key: key);

//   final List<DocumentSnapshot<Object?>> listSnap;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//               showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       content: SizedBox(
//                         width: context.dynamicWidth(0.20),
//                         height: context.dynamicHeight(0.30),
//                         child: Form(
//                           key: formKey,
//                           child: Column(
//                             children: [
//                               TextField(
//                                 controller: taskName,
//                                 decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     labelText: 'Görev Ekle'),
//                               ),
//                               SizedBox(height: context.dynamicHeight(0.05)),
//                               TextField(
//                                 controller: taskDescription,
//                                 decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     labelText: 'Görev Açıklaması'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   Map<String, dynamic> taskData = {
//                                     'taskName': taskName.text,
//                                     'taskDescription': taskDescription.text
//                                   };
//                                   await tasks.doc(taskName.text).set(taskData);
//                                   setState(() {
//                                     taskName.clear();
//                                     taskDescription.clear();
//                                   });
//                                 },
//                                 child: const StyledText(
//                                   text: 'Kaydet',
//                                   color: ColorConstants.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//         },
//         icon: const Icon(
//           EvaIcons.editOutline,
//           color: Colors.orange,
//         ));
//   }
// }
