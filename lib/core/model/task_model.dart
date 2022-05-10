class Task {
  final String name;
  final String description;
  final String date;
  final bool completed;
  final int selectedIconIndex;

  Task(
      {required this.name,
      required this.description,
      required this.date,
      required this.completed,
      required this.selectedIconIndex,
      


      });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'completed': completed,
        'selectedIconIndex': selectedIconIndex,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
      name: json['name'],
      description: json['description'],
      date: json['date'],
      completed: json['completed'],
      selectedIconIndex: json['selectedIconIndex']
      );
}
