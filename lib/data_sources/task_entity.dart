import 'package:hive_flutter/adapters.dart';

//name provided by the generator to the adapter
//this name is used to generate the file name
//to generate the adapter run:
//flutter packages pub run build_runner build
//this will generate the file task_entity.g.dart
//in the same directory as this file
part 'task_entity.g.dart';

//HiveType annotation is used to generate the adapter
//for the TaskEntity class
//These convert the objects to and from binary forms
//typeId is used to identify the class
//when it is serialized
//the typeId must be unique
//for each class
@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  bool isCompleted;
  @HiveField(3)
  int index = 0;
  @HiveField(4)
  final DateTime? createdAt;

  TaskEntity({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  TaskEntity.fromJson(Map<dynamic, dynamic> json)
    : title = json['title'],
      description = json['description'],
      isCompleted = json['isCompleted'],
      index = json['index'],
      createdAt = json['createdAt'];

  void setIndex(int index) {
    this.index = index;
  }

  String get getDatetime {
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  Map<dynamic, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'index': index,
    'createdAt': createdAt,
  };
}
