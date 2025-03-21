import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              globals.smallBoxSpace,
              Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
              globals.smallBoxSpace,
              ValueListenableBuilder<List<TaskEntity>>(
                valueListenable: _viewmodel,
                builder: (context, tasks, child) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.index.toString()),
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                letterSpacing: 2,
                                color: globals.primaryLightColor,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) async {
                          await _viewmodel.removeTask(task);
                        },
                        child: listItem(task),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () async {
          _viewmodel.addTask(
            TaskEntity(
              title: 'Test',
              description: 'This is a test task',
              isCompleted: false,
            ),
          );
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget listItem(TaskEntity task) {
    double height = 60;
    return ListTile(
      title: Row(
        children: [
          Container(
            height: height,
            width: 50,
            color: Theme.of(context).colorScheme.tertiary,
            child: Center(
              child: Text(
                task.index.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  letterSpacing: 2,
                  color: globals.primaryLightColor.withAlpha(200),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        activeColor: Theme.of(context).colorScheme.primary,
        checkColor: Theme.of(context).colorScheme.tertiary,
        focusColor: Theme.of(context).colorScheme.tertiary,
        hoverColor: Theme.of(context).colorScheme.tertiary,
        value: task.isCompleted,
        onChanged: (value) async {
          await _viewmodel.toggleTask(task);
        },
      ),
    );
  }
}
