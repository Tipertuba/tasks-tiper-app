import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/error.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/models/task.dart';

@immutable
abstract class TaskFormState {
  const TaskFormState();
}

@immutable
class SendingState extends TaskFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TaskFormState {
  const ShowFormState();
}

@immutable
class SentState extends TaskFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TaskFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TaskFormCubit extends Cubit<TaskFormState> {
  TaskFormCubit() : super(ShowFormState());

  void save(Project project, Task task, BuildContext context) async {
    emit(SendingState());
    await _send(project, task, context);
  }

  _send(Project project, Task task, BuildContext context) async {
    await ProjectWebClient()
        .addTaskToProject(project, task)
        .then((project) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState(e.message));
    });
  }
}

class TaskFormContainer extends BlocContainer {
  final Project _project;
  final Task _task;

  TaskFormContainer(this._project, this._task);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskFormCubit>(
        create: (BuildContext context) {
          return TaskFormCubit();
        },
        child: BlocListener<TaskFormCubit, TaskFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: TaskFormStateless(this._project, _task),
        ));
  }
}

class TaskFormStateless extends StatelessWidget {
  final Project _project;
  final Task _task;

  TaskFormStateless(this._project, this._task);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFormCubit, TaskFormState>(builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(this._project, _task);
      } else if (state is SendingState || state is SentState) {
        return ProgressView();
      } else if (state is FatalErrorFormState) {
        return ErrorView(state._message);
      }
    });
  }
}

class _BasicForm extends StatelessWidget {
  final Project _project;
  final Task _task;
  final TextEditingController _taskNameController = TextEditingController();

  _BasicForm(this._project, this._task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _taskNameController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Create'),
                    onPressed: () {
                      final String name = _taskNameController.text;
                      final Task task = Task(0, name, false);
                      BlocProvider.of<TaskFormCubit>(context)
                          .save(_project, task, context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
