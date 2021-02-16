import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_bloc.dart';
import 'package:tiperapp/blocs/projects/projects_event.dart';
import 'package:tiperapp/blocs/simple_bloc_observer.dart';
import 'package:tiperapp/components/theme.dart';
import 'package:tiperapp/constants/tiper_app_routes.dart';
import 'package:tiperapp/http/webclients/project_webclient.dart';
import 'package:tiperapp/screens/dashboard.dart';
import 'package:tiperapp/screens/project_list.dart';

void main() {
  runApp(TiperApp());
}

class TiperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: tiperAppTheme, routes: {
      TiperAppRoutes.dashboard: (context) {
        return Dashboard();
      },
      TiperAppRoutes.projects: (context) {
        return BlocProvider<ProjectsBloc>(
          create: (context) {
            return ProjectsBloc(projectWebClient: ProjectWebClient())
              ..add(ProjectsLoaded());
          },
          child: ProjectList(),
        );
      }
    });
  }
}
