// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:minimalist_todo/repository/home_repository.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:result_dart/result_dart.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class HomeViewmodel extends ValueNotifier<List<TaskEntity>> {
  HomeViewmodel(this.context) : super([]);
  final BuildContext context;

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

  Future<void> updateArquived() async {
    await _repository
        .getArquivedTasks()
        .onSuccess((success) => value = success)
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> addTask(TaskEntity task) async {
    await _repository
        .addTask(task)
        .onSuccess((success) async => await update())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> removeTask(TaskEntity task) async {
    await _repository
        .removeTask(task)
        .onSuccess((success) async {
          await update();
          globals.showToaster(context, 'Apagado');
        })
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> arquiveTask(TaskEntity task) async {
    await _repository
        .arquiveTask(task)
        .onSuccess((success) async => await update())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> unarquiveTask(TaskEntity task) async {
    await _repository
        .unarquiveTask(task)
        .onSuccess((success) async => await updateArquived())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> toggleTask(TaskEntity task) async {
    await _repository
        .toggleTask(task)
        .onSuccess((success) async => await update())
        .onFailure((failure) => log(failure.toString()));
  }

  Future<void> updateTask(TaskEntity task) async {
    await _repository
        .updateTask(task)
        .onSuccess((success) async {
          await update();
          globals.showToaster(context, 'Atualizado');
        })
        .onFailure((failure) => log(failure.toString()));
  }
}
