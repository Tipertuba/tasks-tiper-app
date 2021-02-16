import 'package:equatable/equatable.dart';
import 'package:tiperapp/models/project.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  List<Object> get props => [];
}

class ProjectsLoaded extends ProjectsEvent {}

class ProjectAdded extends ProjectsEvent {
  final Project project;

  const ProjectAdded(this.project);

  @override
  List<Object> get props => [project];

  @override
  String toString() => 'ProjectAdded { project: $project }';
}