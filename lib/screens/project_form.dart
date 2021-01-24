import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/error.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ProjectFormState {
  const ProjectFormState();
}

@immutable
class SendingState extends ProjectFormState {
  const SendingState();
}

@immutable
class ShowFormState extends ProjectFormState {
  const ShowFormState();
}

@immutable
class SentState extends ProjectFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends ProjectFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class ProjectFormCubit extends Cubit<ProjectFormState> {
  ProjectFormCubit() : super(ShowFormState());

  void save(Project projectCreated, BuildContext context) async {
    emit(SendingState());
    await _send(projectCreated, context);
  }

  _send(Project project, BuildContext context) async {
    await ProjectWebClient()
        .save(project)
        .then((project) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
      emit(FatalErrorFormState('timeout submitting the transaction'));
    }, test: (e) => e is TimeoutException).catchError((e) {
      emit(FatalErrorFormState(e.message));
    });
  }
}

class ProjectFormContainer extends BlocContainer {
  final Project _project;

  ProjectFormContainer(this._project);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectFormCubit>(
        create: (BuildContext context) {
          return ProjectFormCubit();
        },
        child: BlocListener<ProjectFormCubit, ProjectFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: ProjectFormStateless(_project),
        ));
  }
}

class ProjectFormStateless extends StatelessWidget {
  final Project _project;

  ProjectFormStateless(this._project);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectFormCubit, ProjectFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(_project);
      } else if (state is SendingState || state is SentState) {
        return ProgressView();
      } else if (state is FatalErrorFormState) {
        return ErrorView(state._message);
      }
      return ErrorView("Unknown Error");
    });
  }
}

class _BasicForm extends StatelessWidget {
  final Project _project;
  final TextEditingController _projectNameController = TextEditingController();

  _BasicForm(this._project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New project'),
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
                  controller: _projectNameController,
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
                      final String name = _projectNameController.text;
                      final Project project = Project(0, name);
                      BlocProvider.of<ProjectFormCubit>(context)
                          .save(project, context);
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
