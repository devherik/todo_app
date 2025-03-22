import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist_todo/view/addtask_modal_widget.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late HomeViewmodel _viewmodel;
  late AnimationController _animationController;

  @override
  void initState() {
    _viewmodel = HomeViewmodel(context);
    _viewmodel.initialize();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Tarefas', style: Theme.of(context).textTheme.titleSmall),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu_rounded),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: listItem(task),
                      );
                    },
                  );
                },
              ),
              globals.largeBoxSpace,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () async {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AddtaskModalWidget(viewmodel: _viewmodel),
          );
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget listItem(TaskEntity task) {
    Animation<double> animation = Tween<double>(begin: 60, end: 80).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      },
      child: ListTile(
        title: Row(
          children: [
            Container(
              height: animation.value,
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
              height: animation.value,
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
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
      ),
    );
  }
}
