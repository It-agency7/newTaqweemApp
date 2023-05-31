import 'task_model.dart';

class NoteModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String time;
  final List<TaskModel> tasks;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.tasks = const [],
  });

  copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? time,
    bool? alarmActivated,
    List<TaskModel>? tasks,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      tasks: tasks ?? this.tasks,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'],
        title: json['title'],
        description: json['notes'],
        date: json['date'],
        time: json['time'],
        tasks: (json['tasks'] as List)
            .map((task) => TaskModel.fromJson(task))
            .toList(),
      );
}
