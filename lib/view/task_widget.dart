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
  bool areFieldsValid = false;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleController.text = widget._taskEntity.title;
    descriptionController.text = widget._taskEntity.description;
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
            Align(
              alignment: Alignment.centerLeft,
              child: Builder(
                builder:
                    (context) => IconButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty) {
                          await widget._viewmodel.addTask(
                            TaskEntity(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              isCompleted: false,
                              createdAt: DateTime.now(),
                            ),
                          );
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
              ),
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
        autofocus: true,
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
        maxLength: 10,
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

  Widget _buildButton() {
    return Builder(
      builder: (context) {
        return MaterialButton(
          elevation: 0,
          minWidth: double.infinity,
          clipBehavior: Clip.antiAlias,
          disabledColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.scrim,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          onPressed:
              areFieldsValid
                  ? () async {
                    await widget._viewmodel
                        .addTask(
                          TaskEntity(
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            isCompleted: false,
                            createdAt: DateTime.now(),
                          ),
                        )
                        .whenComplete(() {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        });
                  }
                  : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              'ADICIONAR',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        );
      },
    );
  }
}
