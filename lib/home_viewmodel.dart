import 'package:flutter/cupertino.dart';
import 'package:minimalist_todo/task_entity.dart';

class HomeViewmodel extends ValueNotifier<List<TaskEntity>> {
  HomeViewmodel() : super([]);

  void update() {}
  addTask(TaskEntity task) {}
  removeTask(TaskEntity task) {}
  toggleTask(TaskEntity task) {}
}
