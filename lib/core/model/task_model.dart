class Task {
  final String name;
  final String description;
  final String time;
  final String date;
  final bool completed;

  Task(
      {required this.name,
      required this.description,
      required this.time,
      required this.date,
      required this.completed});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'time': time,
        'date': date,
        'completed': completed,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
      name: json['name'],
      description: json['description'],
      time: json['time'],
      date: json['date'],
      completed: json['completed']);
}
