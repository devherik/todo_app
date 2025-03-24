import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

import 'package:minimalist_todo/config/globals_app.dart' as globals;

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              _heigth == 80
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white70,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: _toggleTask()),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 8, child: Divider()),
                  _heigth == 150 ? _buildDescription() : Container(),
                ],
              ),
            ),
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
        Text(
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
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.tertiary,
      icon: Icon(
        widget._taskEntity.isCompleted ? Iconsax.verify : Icons.circle_outlined,
      ),
    );
  }
}
