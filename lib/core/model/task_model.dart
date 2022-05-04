import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String name;
  final String description;

  final Timestamp date;
  final bool completed;

  Task(
      {required this.name,
      required this.description,
      required this.date,
      required this.completed});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'completed': completed,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
      name: json['name'],
      description: json['description'],
      date: json['date'],
      completed: json['completed']);
}
