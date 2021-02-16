import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/task_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/models/task.dart';
import 'package:tiperapp/screens/task_form.dart';

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
class LoadedTaskState extends TaskListState {
  final Task _task;

  const LoadedTaskState(this._task);
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

  completeTask(Task task) async {
    await TaskWebClient().completeTask(task).then((value) => emit(LoadedTaskState(value))).catchError((e) {
      emit(FatalErrorTaskListState(e.message));
    });
  }

  _fetch(Project project) async {
    await TaskWebClient().findTasks(project).then((value) => emit(LoadedTaskListState(project, value))).catchError((e) {
      emit(FatalErrorTaskListState(e.message));
    });
  }

  _updateTaskOfProject(Project project, Task task) {
    // project.task
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
      child: TaskList(this._project),
    );
  }
}

class TaskList extends StatelessWidget {
  final Project _project;

  TaskList(this._project);

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
                    completeTaskFunction: () {
                      completeTask(context, task);
                    },
                  );
                });
          }
          if (state is LoadedTaskState) {}
          return const Text("Unknown Error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskFormContainer(this._project, Task(0, "", false))));
          update(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void update(BuildContext context) {
    context.read<TaskListCubit>().reload();
  }

  void completeTask(BuildContext context, Task task) {
    context.read<TaskListCubit>().completeTask(task);
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final Function onClick;
  final Function completeTaskFunction;

  _TaskItem(this.task, {@required this.onClick, @required this.completeTaskFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        leading: IconButton(
          icon: Icon(task.completed ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded),
          onPressed: () {
            completeTaskFunction();
          },
        ),
        title: Text(task.name),
        subtitle: Text("Shroubles"),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
