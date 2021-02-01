import 'dart:convert';

import 'package:http/http.dart';
import 'package:tiperapp/http/webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/models/task.dart';

const projectResource = "/project";

class ProjectWebClient {
  Future<List<Project>> findAll() async {
    final Response response = await client.get(baseUrl + projectResource);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Project.fromJson(json)).toList();
  }

  Future<Project> save(Project project) async {
    final String projectJson = jsonEncode(project.toJson());

    await Future.delayed(Duration(seconds: 1));

    final Response response = await client.post(baseUrl + projectResource,
        headers: {'Content-Type': 'application/json'}, body: projectJson);

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  Future<Project> addTaskToProject(Project project, Task task) async {
    final String taskJson = jsonEncode(task.toJson());

    await Future.delayed(Duration(milliseconds: 500));

    final Response response = await client.post(
        '$baseUrl$projectResource/${project.id}/task',
        headers: {'Content-Type': 'application/json'},
        body: taskJson);

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return 'unknown error';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'there was an error submitting transaction',
    401: 'authentication failed',
    409: 'transaction already exists'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
