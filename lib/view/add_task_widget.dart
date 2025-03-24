import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key, required HomeViewmodel viewmodel})
    : _viewmodel = viewmodel;
  final HomeViewmodel _viewmodel;

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool areFieldsValid = false;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleController.addListener(() {
      setState(() => areFieldsValid = titleController.text.isNotEmpty);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Nova tarefa', style: Theme.of(context).textTheme.titleSmall),
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Iconsax.close_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
          ),
        ],
      ),
      actions: <Widget>[_buildButton()],
      actionsPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            globals.largeBoxSpace,
            _buildFormField(titleController, 'Título', 1, 18),
            globals.verySmallBoxSpace,
            _buildFormField(descriptionController, 'Descrição', 5, 80),
            globals.smallBoxSpace,
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildFormField(
    TextEditingController controller,
    String hintText,
    int lines,
    int maxLength,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: Theme.of(context).textTheme.bodyLarge,
        maxLength: maxLength,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          counterStyle: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          suffix: Builder(
            builder:
                (context) => IconButton(
                  onPressed: () => controller.clear(),
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
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
