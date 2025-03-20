import 'package:flutter/material.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';

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
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text('Tasks'),
            const SizedBox(height: 16),
            ValueListenableBuilder<List<TaskEntity>>(
              valueListenable: _viewmodel,
              builder: (context, tasks, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: GestureDetector(
                        child: Text('${task.title} | ${task.index}'),
                        onLongPress:
                            () async => await _viewmodel.removeTask(task),
                      ),
                      subtitle: Text(task.description),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) async {
                          await _viewmodel.toggleTask(task);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _viewmodel.addTask(
            TaskEntity(
              title: 'Test',
              description: 'This is a test task',
              isCompleted: false,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
