import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/components/container.dart';
import 'package:tiperapp/components/progress.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/screens/project_form.dart';
import 'package:tiperapp/screens/task_list.dart';

@immutable
abstract class ProjectsListState {
  const ProjectsListState();
}

@immutable
class LoadingProjectsListState extends ProjectsListState {
  const LoadingProjectsListState();
}

@immutable
class InitProjectsListState extends ProjectsListState {
  const InitProjectsListState();
}

@immutable
class LoadedProjectsListState extends ProjectsListState {
  final List<Project> _projects;

  const LoadedProjectsListState(this._projects);
}

@immutable
class FatalErrorProjectsListState extends ProjectsListState {
  final String _message;

  const FatalErrorProjectsListState(this._message);
}

class ProjectsListCubit extends Cubit<ProjectsListState> {
  ProjectsListCubit() : super(InitProjectsListState());

  void reload() async {
    emit(LoadingProjectsListState());
    _fetch();
  }

  _fetch() async {
    await ProjectWebClient()
        .findAll()
        .then((value) => emit(LoadedProjectsListState(value)))
        .catchError((e) {
      emit(FatalErrorProjectsListState(e.message));
    });
  }
}

class ProjectsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsListCubit>(
      create: (BuildContext context) {
        final cubit = ProjectsListCubit();
        cubit.reload();
        return cubit;
      },
      child: ProjectList(),
    );
  }
}

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: BlocBuilder<ProjectsListCubit, ProjectsListState>(
        builder: (context, state) {
          if (state is InitProjectsListState ||
              state is LoadingProjectsListState) {
            return Progress();
          }
          if (state is LoadedProjectsListState) {
            final projects = state._projects;
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
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProjectFormContainer(Project(0, ""))));
          update(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void update(BuildContext context) {
    context.read<ProjectsListCubit>().reload();
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
