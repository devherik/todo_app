import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/view/add_task_widget.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Minhas tarefas',
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.tertiary.withAlpha(150),
              ),
            ),
            //TODO: add an animation when changing the tasks list
            Text(
              _isArquived ? 'Arquivadas' : 'Ativas',
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 6,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () async {
                    //change the tasks list to the arquived tasks and vice versa
                    if (!_isArquived) {
                      await _viewmodel.updateArquived();
                    } else {
                      await _viewmodel.update();
                    }
                    setState(() => _isArquived = !_isArquived);
                  },
                  icon: Icon(Iconsax.arrow_swap_horizontal),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
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
                          margin: const EdgeInsets.all(8),
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
                          margin: const EdgeInsets.all(8),
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
                      );
                    },
                  );
                },
              ),
            ),
            _addButton(),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return Builder(
      builder: (context) {
        return MaterialButton(
          elevation: 2,
          minWidth: MediaQuery.of(context).size.width * .4,
          height: 75,
          color: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            showDialog(
              context: context,
              useSafeArea: true,
              builder: (context) => AddTaskWidget(viewmodel: _viewmodel),
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
