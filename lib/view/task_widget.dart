import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required HomeViewmodel viewmodel,
    required TaskEntity taskEntity,
  }) : _viewmodel = viewmodel,
       _taskEntity = taskEntity;
  final HomeViewmodel _viewmodel;
  final TaskEntity _taskEntity;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isUpdating = false;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleController.text = widget._taskEntity.title;
    descriptionController.text = widget._taskEntity.description;
    widget._taskEntity.title != '' ? isUpdating = true : isUpdating = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_backButton(), _toggleButton()],
            ),
            globals.largeBoxSpace,
            _buildTitleFormField(),
            _buildDescriptionFormField(),
            globals.smallBoxSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTitleFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        focusNode: FocusNode(),
        autofocus: isUpdating ? false : true,
        controller: titleController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: Theme.of(context).textTheme.titleSmall,
        maxLength: 18,
        maxLines: 1,
        decoration: InputDecoration(
          counter: SizedBox(),
          hintText: widget._taskEntity.title == '' ? 'Título' : null,
          hintStyle: Theme.of(context).textTheme.titleSmall,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        focusNode: FocusNode(),
        autofocus: false,
        controller: descriptionController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: Theme.of(context).textTheme.bodyLarge,
        maxLength: 200,
        maxLines: 7,
        decoration: InputDecoration(
          counter: SizedBox(),
          hintText: widget._taskEntity.description == '' ? 'Descrição' : null,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Builder(
      builder:
          (context) => IconButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final newTask = TaskEntity(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  isCompleted: widget._taskEntity.isCompleted,
                  createdAt: widget._taskEntity.createdAt,
                );
                newTask.index = widget._taskEntity.index;
                isUpdating
                    ? await widget._viewmodel.updateTask(newTask)
                    : await widget._viewmodel.addTask(newTask);
              }
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            icon: Icon(
              Iconsax.arrow_left,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
    );
  }

  Widget _toggleButton() {
    return Builder(
      builder:
          (context) => IconButton(
            onPressed: () async {
              widget._taskEntity.isCompleted = !widget._taskEntity.isCompleted;
              await widget._viewmodel.toggleTask(widget._taskEntity);
              setState(() {});
            },
            icon: Icon(
              widget._taskEntity.isCompleted
                  ? Iconsax.toggle_on_circle5
                  : Iconsax.toggle_off_circle,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
    );
  }

  @override
  void dispose() {
    if (titleController.text.isNotEmpty) {
      final newTask = TaskEntity(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        isCompleted: widget._taskEntity.isCompleted,
        createdAt: widget._taskEntity.createdAt,
      );
      newTask.index = widget._taskEntity.index;
      isUpdating
          ? widget._viewmodel.updateTask(newTask)
          : widget._viewmodel.addTask(newTask);
    }
    super.dispose();
  }
}
