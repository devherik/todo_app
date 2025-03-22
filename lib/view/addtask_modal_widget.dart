import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class AddtaskModalWidget extends StatefulWidget {
  const AddtaskModalWidget({super.key, required HomeViewmodel viewmodel})
    : _viewmodel = viewmodel;
  final HomeViewmodel _viewmodel;

  @override
  State<AddtaskModalWidget> createState() => _AddtaskModalWidgetState();
}

class _AddtaskModalWidgetState extends State<AddtaskModalWidget> {
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  );
                },
              ),
            ),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Text(
                  'Crie uma nova tarefa.',
                  style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    letterSpacing: 2,
                    color: globals.primaryLightColor,
                  ),
                ),
                globals.largeBoxSpace,
                _buildFormField(titleController, 'Título', 1, 15),
                globals.verySmallBoxSpace,
                _buildFormField(descriptionController, 'Descrição', 2, 100),
              ],
            ),
          ),
          globals.smallBoxSpace,
          _buildButton(),
        ],
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
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        maxLength: maxLength,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: hintText,
          suffix: Builder(
            builder:
                (context) => IconButton(
                  onPressed: () => controller.clear(),
                  icon: Icon(Icons.clear),
                ),
          ),
          border: UnderlineInputBorder(),
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
          disabledColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.scrim,
          onPressed:
              areFieldsValid
                  ? () async {
                    await widget._viewmodel
                        .addTask(
                          TaskEntity(
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            isCompleted: false,
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
