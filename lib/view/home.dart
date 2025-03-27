import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/view/app_bar_widget.dart';
import 'package:minimalist_todo/view/task_widget.dart';
import 'package:minimalist_todo/view/listitem_widget.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeViewmodel _viewmodel;
  bool _isArquived = false;

  @override
  void initState() {
    _viewmodel = HomeViewmodel(context);
    _viewmodel.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        centerTitle: false,
        title: AppBarTextWidget(viewmodel: _viewmodel),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: ValueListenableBuilder<List<TaskEntity>>(
                valueListenable: _viewmodel,
                builder: (context, tasks, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Dismissible(
                          key: Key(task.index.toString()),
                          background: Container(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: globals.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _isArquived ? 'Restaurar' : 'Arquivar',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: globals.primaryDarkColor,
                                ),
                              ),
                            ),
                          ),
                          secondaryBackground: Container(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: globals.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Apagar',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: globals.primaryDarkColor,
                                ),
                              ),
                            ),
                          ),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _isArquived
                                  ? await _viewmodel.unarquiveTask(task)
                                  : await _viewmodel.arquiveTask(task);
                            } else {
                              await _viewmodel.removeTask(task);
                            }
                          },
                          behavior: HitTestBehavior.translucent,
                          child: ListitemWidget(
                            viewmodel: _viewmodel,
                            taskEntity: task,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _addButton(),
    );
  }

  Widget _addButton() {
    return Builder(
      builder: (context) {
        return MaterialButton(
          elevation: 2,
          minWidth: MediaQuery.of(context).size.width * .25,
          height: 65,
          color: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
              enableDrag: false,
              isDismissible: true,
              useSafeArea: false,
              isScrollControlled: true,
              builder:
                  (context) => TaskWidget(
                    viewmodel: _viewmodel,
                    taskEntity: TaskEntity(
                      title: '',
                      description: '',
                      isCompleted: false,
                      createdAt: DateTime.now(),
                    ),
                  ),
            );
          },
          child: Icon(
            Iconsax.add,
            size: 24,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        );
      },
    );
  }
}
