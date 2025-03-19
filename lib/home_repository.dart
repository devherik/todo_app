import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:minimalist_todo/task_entity.dart';
import 'package:result_dart/result_dart.dart';

class HomeRepository {
  HomeRepository._();
  static HomeRepository? _instance;
  late Box box;

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
      box = await Hive.openBox('tasks');
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<TaskEntity>, Exception>> getTasks() async {
    final List<TaskEntity> tasks = [];
    try {
      final data = box.values;
      for (final item in data) {
        tasks.add(TaskEntity.fromJson(item));
      }
      return Success(tasks);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> addTask(TaskEntity task) async {
    try {
      await box.add(task.toJson());
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> removeTask(TaskEntity task) async {
    try {
      await box.deleteAt(box.values.toList().indexOf(task.toJson()));
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> toggleTask(TaskEntity task) async {
    try {
      final index = box.values.toList().indexOf(task.toJson());
      final data = box.getAt(index);
      final updatedTask = TaskEntity.fromJson(data);
      updatedTask.isCompleted = !updatedTask.isCompleted;
      await box.putAt(index, updatedTask.toJson());
      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
