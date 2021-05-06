import 'package:equatable/equatable.dart';
import 'package:tiperapp/models/project.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsLoadInProgress extends ProjectsState {}

class ProjectsLoadSuccess extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoadSuccess([this.projects = const []]);

  @override
  List<Object> get props => [projects];

  @override
  String toString() => 'ProjectsLoadSuccess { projects: $projects }';
}

class ProjectsLoadFailure extends ProjectsState {}