class TaskModel {
  final String id;
  final String title;
  final bool isFinished;

  TaskModel({
    required this.id,
    required this.title,
    required this.isFinished,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isFinished,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'],
      isFinished: json['status'] != "1",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': "00:00:00",
      'status': isFinished ? "1" : "2",
    };
  }
}
