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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            _buildFormField(titleController, 'Título', 1, 18),
            _buildFormField(descriptionController, 'Descrição', 7, 100),
            globals.smallBoxSpace,
          ],
        ),
      ),
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
      child: TextFormField(
        focusNode: FocusNode(),
        autofocus: true,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style:
            hintText == 'Título'
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.bodyLarge,
        maxLength: maxLength,
        maxLines: lines,
        decoration: InputDecoration(
          counter: SizedBox(),
          hintText: hintText,
          hintStyle:
              hintText == 'Título'
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.bodyLarge,
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
