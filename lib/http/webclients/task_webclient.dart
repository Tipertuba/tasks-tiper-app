import 'dart:convert';

import 'package:http/http.dart';
import 'package:tiperapp/http/webclient.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/models/task.dart';

const projectResource = "/project";
const taskResource = "/task";

class TaskWebClient {
  Future<List<Task>> findTasks(Project project) async {
    final Response response = await client.get('$baseUrl$projectResource/${project.id}/task');
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Task.fromJson(json)).toList();
  }

  Future<Task> completeTask(Task task) async {
    final Response response = await client.post('$baseUrl$taskResource/${task.id}/complete');
    return Task.fromJson(jsonDecode(response.body));
  }
}
