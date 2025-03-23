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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  _heigth == 150
                      ? const SizedBox(height: 8, child: Divider())
                      : Container(),
                  _heigth == 150 ? _buildDescription() : Container(),
                ],
              ),
            ),
            _heigth == 150
                ? Expanded(flex: 1, child: _toggleTask())
                : Container(),
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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        _heigth == 80
            ? Text(
              widget._taskEntity.isCompleted ? 'Concluída' : 'Ativa',
              style: Theme.of(context).textTheme.labelMedium,
            )
            : Text(
              widget._taskEntity.getDatetime,
              style: Theme.of(context).textTheme.labelMedium,
            ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget._taskEntity.description,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }

  Widget _toggleTask() {
    return IconButton(
      onPressed: () async {
        widget._taskEntity.isCompleted = !widget._taskEntity.isCompleted;
        await widget._viewmodel.toggleTask(widget._taskEntity);
      },
      icon: Icon(
        widget._taskEntity.isCompleted
            ? Icons.check_circle
            : Icons.circle_outlined,
      ),
    );
  }
}
