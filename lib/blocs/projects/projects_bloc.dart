import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiperapp/blocs/projects/projects_event.dart';
import 'package:tiperapp/blocs/projects/projects_state.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {

  //TODO: create a repository that can handle both local storage and web client
  final ProjectWebClient projectWebClient;

  ProjectsBloc({@required this.projectWebClient})
      : super(ProjectsLoadInProgress());

  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async* {
    if (event is ProjectsLoaded) {
      yield* _mapProjectsLoadedToState();
    }
  }

  Stream<ProjectsState> _mapProjectsLoadedToState() async* {
    try {
      final projects = await this.projectWebClient.findAll();
      yield ProjectsLoadSuccess(projects);
    } catch (_) {
      yield ProjectsLoadFailure();
    }
  }

}