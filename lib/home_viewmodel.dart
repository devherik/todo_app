import 'package:flutter/cupertino.dart';

class HomeViewmodel extends ValueNotifier<List<TaskEntity>> {
  HomeViewmodel() : super([]);

  void update() {}
  addTask(TaskEntity task) {}
  removeTask(TaskEntity task) {}
  toggleTask(TaskEntity task) {}
}

class TaskEntity {
  final String title;
  final String description;
  final bool isCompleted;

  TaskEntity({
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  TaskEntity.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      description = json['description'],
      isCompleted = json['isCompleted'];
}
