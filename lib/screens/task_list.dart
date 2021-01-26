import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/task_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/models/task.dart';

@immutable
abstract class TaskListState {
  const TaskListState();
}

@immutable
class LoadingTaskListState extends TaskListState {
  const LoadingTaskListState();
}

@immutable
class InitTaskListState extends TaskListState {
  const InitTaskListState();
}

@immutable
class LoadedTaskListState extends TaskListState {
  final Project _project;
  final List<Task> _tasks;

  const LoadedTaskListState(this._project, this._tasks);
}

@immutable
class FatalErrorTaskListState extends TaskListState {
  final String _message;

  const FatalErrorTaskListState(this._message);
}

class TaskListCubit extends Cubit<TaskListState> {
  final Project _project;

  TaskListCubit(this._project) : super(InitTaskListState());

  void reload() async {
    emit(LoadingTaskListState());
    _fetch(this._project);
  }

  _fetch(Project project) async {
    await TaskWebClient()
        .findTasks(project)
        .then((value) => emit(LoadedTaskListState(project, value)))
        .catchError((e) {
      emit(FatalErrorTaskListState(e.message));
    });
  }
}

class TaskListContainer extends BlocContainer {

  final Project _project;

  TaskListContainer(this._project);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskListCubit>(
      create: (BuildContext context) {
        final cubit = TaskListCubit(this._project);
        cubit.reload();
        return cubit;
      },
      child: TaskList(),
    );
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state is InitTaskListState || state is LoadingTaskListState) {
            return Progress();
          }
          if (state is LoadedTaskListState) {
            final tasks = state._tasks;
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _TaskItem(
                    task,
                    onClick: () {
                      push(context, TaskListContainer(state._project));
                    },
                  );
                });
          }
          return const Text("Unknown Error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final Function onClick;

  _TaskItem(this.task, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        leading: FlutterLogo(),
        title: Text(task.name),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
