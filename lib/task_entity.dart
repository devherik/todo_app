import 'package:hive_flutter/adapters.dart';

//name provided by the generator to the adapter
//this name is used to generate the file name
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

  TaskEntity({
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  TaskEntity.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      description = json['description'],
      isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
  };
}
