import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:minimalist_todo/home_repository.dart';
import 'package:minimalist_todo/task_entity.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewmodel extends ValueNotifier<List<TaskEntity>> {
  HomeViewmodel() : super([]);

  final HomeRepository _repository = HomeRepository.getInstance();

  Future<void> initialize() async {
    await _repository.initialize();
    await _repository
        .getTasks()
        .onSuccess((success) => value = success)
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> update() async {
    await _repository
        .getTasks()
        .onSuccess((success) => value = success)
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> addTask(TaskEntity task) async {
    await _repository
        .addTask(task)
        .onSuccess((success) => update())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> removeTask(TaskEntity task) async {
    await _repository
        .removeTask(task)
        .onSuccess((success) => update())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> toggleTask(TaskEntity task) async {
    await _repository
        .toggleTask(task)
        .onSuccess((success) => update())
        .onFailure((failure) => log(failure.toString()));
  }
}
