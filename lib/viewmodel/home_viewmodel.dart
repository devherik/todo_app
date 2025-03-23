import 'package:flutter/cupertino.dart';
import 'package:minimalist_todo/repository/home_repository.dart';
import 'package:minimalist_todo/main.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewmodel extends ValueNotifier<List<TaskEntity>> {
  HomeViewmodel(this.context) : super([]);
  final BuildContext context;

  final HomeRepository _repository = HomeRepository.getInstance();

  Future<void> initialize() async {
    await _repository.initialize();
    await _repository
        .getTasks()
        .onSuccess((success) => value = success)
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }

  Future<void> update() async {
    await _repository
        .getTasks()
        .onSuccess((success) => value = success)
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }

  Future<List<TaskEntity>> updateArquived() async {
    List<TaskEntity> tasks = [];
    await _repository
        .getArquivedTasks()
        .onSuccess((success) {
          tasks = success;
        })
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
    return tasks;
  }

  Future<void> addTask(TaskEntity task) async {
    await _repository
        .addTask(task)
        .onSuccess((success) async => await update())
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }

  Future<void> removeTask(TaskEntity task) async {
    await _repository
        .removeTask(task)
        .onSuccess((success) async {
          await update();
        })
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }

  Future<void> arquiveTask(TaskEntity task) async {
    await _repository
        .arquiveTask(task)
        .onSuccess((success) async {
          await update();
        })
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }

  Future<void> toggleTask(TaskEntity task) async {
    await _repository
        .toggleTask(task)
        .onSuccess((success) async => await update())
        .onFailure(
          (failure) => MyApp.of(context)!.showToaster(failure.toString()),
        );
  }
}
