import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_state.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/screens/project_form.dart';
import 'package:tiperapp/screens/task_list.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoadInProgress) {
            return Progress();
          } else if (state is ProjectsLoadSuccess) {
            final projects = state.projects;
            return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return _ProjectItem(
                    project,
                    onClick: () {
                      push(context, TaskListContainer(project));
                    },
                  );
                });
          }
          return const Text("Unknown Error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProjectFormContainer(Project(0, "")),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  final Project project;
  final Function onClick;

  _ProjectItem(this.project, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        leading: FlutterLogo(),
        title: Text(project.name),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
