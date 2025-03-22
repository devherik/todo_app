import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist_todo/view/addtask_modal_widget.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minhas tarefas',
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              'ativas',
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.tertiary.withAlpha(150),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu_rounded),
                ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          globals.smallBoxSpace,
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
                    return Dismissible(
                      key: Key(task.index.toString()),
                      background: Container(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        color: Theme.of(context).colorScheme.error,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Delete',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              letterSpacing: 2,
                              color: globals.primaryDarkColor,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        await _viewmodel.removeTask(task);
                      },
                      child: ListitemWidget(
                        viewmodel: _viewmodel,
                        taskEntity: task,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(flex: 1, child: _addButton()),
        ],
      ),
    );
  }

  Widget _addButton() {
    return Builder(
      builder: (context) {
        return MaterialButton(
          elevation: 0,
          minWidth: double.infinity,
          clipBehavior: Clip.antiAlias,
          disabledColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddtaskModalWidget(viewmodel: _viewmodel),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Icon(
              Icons.add,
              size: 30,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        );
      },
    );
  }
}
