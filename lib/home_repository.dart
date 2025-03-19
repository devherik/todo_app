import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:minimalist_todo/home_viewmodel.dart';
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

  void addTask(TaskEntity task) {}
  void removeTask(TaskEntity task) {}
  void toggleTask(TaskEntity task) {}
}

class TaskEntityAdapter extends TypeAdapter<TaskEntity> {
  @override
  final int typeId = 0;

  @override
  TaskEntity read(BinaryReader reader) {
    return TaskEntity(
      title: reader.readString(),
      description: reader.readString(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskEntity obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeBool(obj.isCompleted);
  }
}
