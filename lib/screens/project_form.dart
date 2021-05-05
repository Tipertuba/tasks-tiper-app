import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_state.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/error.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class AddEditProjectScreenState {
  const AddEditProjectScreenState();
}

@immutable
class SendingState extends AddEditProjectScreenState {
  const SendingState();
}

@immutable
class ShowFormState extends AddEditProjectScreenState {
  const ShowFormState();
}

@immutable
class SentState extends AddEditProjectScreenState {
  const SentState();
}

@immutable
class FatalErrorFormState extends AddEditProjectScreenState {
  final String _message;

  const FatalErrorFormState(this._message);
}

typedef OnSaveCallback = Function(Project project);

class AddEditProjectScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Project project;

  const AddEditProjectScreen({
    Key key,
    @required this.isEditing,
    @required this.onSave,
    this.project,
  }) : super(key: key);

  @override
  _AddEditProjectScreenState createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {

  final TextEditingController _projectNameController = TextEditingController();

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New project'),
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                            widget.onSave(project);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}