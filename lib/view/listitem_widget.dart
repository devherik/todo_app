import 'package:flutter/material.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

class ListitemWidget extends StatefulWidget {
  const ListitemWidget({
    super.key,
    required HomeViewmodel viewmodel,
    required TaskEntity taskEntity,
  }) : _viewmodel = viewmodel,
       _taskEntity = taskEntity;
  final HomeViewmodel _viewmodel;
  final TaskEntity _taskEntity;

  @override
  State<ListitemWidget> createState() => _ListitemWidgetState();
}

class _ListitemWidgetState extends State<ListitemWidget> {
  double _heigth = 80;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _heigth = _heigth == 80 ? 150 : 80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _heigth,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        color:
            _heigth == 80
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.scrim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            _heigth == 150 ? Text(widget._taskEntity.description) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Text(
          widget._taskEntity.title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const Spacer(),
        Text(
          widget._taskEntity.isCompleted ? 'Concluída' : 'Ativa',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
