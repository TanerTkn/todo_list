import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/constant/svg_constant.dart';
import 'package:todo_list/core/model/task_model.dart';

class CompletedController extends GetxController {
  Stream<List<Task>> completedTasks() =>
      FirebaseFirestore.instance.collection('tasks').snapshots().map((event) =>
          event.docs.map((doc) => Task.fromJson(doc.data())).toList());

  List iconBackground = [
    SvgConstant.orangeCircularIcon,
    SvgConstant.deepBlueCircularIcon,
    SvgConstant.lightBlueCircularIcon,
    SvgConstant.pinkblueCircularIcon,
    SvgConstant.orangeCircularIcon,
    SvgConstant.deepBlueCircularIcon,
    SvgConstant.lightBlueCircularIcon,
    SvgConstant.pinkblueCircularIcon,
  ];
  List icons = [
    SvgConstant.weight,
    SvgConstant.coding,
    SvgConstant.console,
    SvgConstant.weight,
    SvgConstant.coding,
    SvgConstant.console,
    SvgConstant.weight,
    SvgConstant.coding,
    SvgConstant.console,
  ];
}
