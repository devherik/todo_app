import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/data_sources/task_entity.dart';
import 'package:minimalist_todo/view/task_widget.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

// ignore: unused_import
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.primary,
            enableDrag: false,
            isDismissible: true,
            useSafeArea: false,
            isScrollControlled: true,
            builder:
                (context) => TaskWidget(
                  viewmodel: widget._viewmodel,
                  taskEntity: widget._taskEntity,
                ),
          ),
      child: Card(
        borderOnForeground: true,
        margin: const EdgeInsets.all(0),
        shadowColor: Theme.of(context).colorScheme.tertiary,
        color: Theme.of(context).colorScheme.primary.withAlpha(700),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                  children: [_buildTitle(), _buildDescription()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            widget._taskEntity.title,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Flexible(
          child: Text(
            widget._taskEntity.getDatetime,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget._taskEntity.description != '' ? '...' : '',
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelLarge,
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
        widget._taskEntity.isCompleted
            ? Iconsax.verify5
            : Icons.circle_outlined,
      ),
    );
  }
}
