import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:result_dart/result_dart.dart';

class HomeRepository {
  HomeRepository._();
  static HomeRepository? _instance;
  late Box tasksBox;
  late Box indexBox;

  //avoid the re-creation of the
  //object by making the
  //constructor
  //private and using a singleton pattern
  factory HomeRepository.getInstance() {
    if (_instance == null) {
      _instance = HomeRepository._();
      log('HomeRepository has been initialized');
      return _instance!;
    } else {
      log('HomeRepository has already been initialized');
      return _instance!;
    }
  }

  Future<Result<bool, Exception>> initialize() async {
    try {
      //register the adapter, must be done before
      //opening the box
      Hive.registerAdapter(TaskEntityAdapter());
      tasksBox = await Hive.openBox('tasks');
      indexBox = await Hive.openBox('index');
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<TaskEntity>, Exception>> getTasks() async {
    final List<TaskEntity> tasks = [];
    try {
      final data = tasksBox.values;
      for (final item in data) {
        tasks.add(TaskEntity.fromJson(item));
      }
      return Success(tasks);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> addTask(TaskEntity task) async {
    int tasksCount = indexBox.get('index', defaultValue: 0);
    try {
      task.setIndex(tasksCount++);
      await tasksBox.add(task.toJson());
      await indexBox.put('index', tasksCount);
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> removeTask(TaskEntity task) async {
    try {
      final data = tasksBox.values.toList();
      final index = data.indexWhere(
        (element) => element['index'] == task.index,
      );
      await tasksBox.deleteAt(index);
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> toggleTask(TaskEntity task) async {
    try {
      final data = tasksBox.values.toList();
      final index = data.indexWhere(
        (element) => element['index'] == task.index,
      );
      final updatedTask = TaskEntity.fromJson(data[index]);
      updatedTask.isCompleted = !updatedTask.isCompleted;
      await tasksBox.putAt(index, updatedTask.toJson());
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
