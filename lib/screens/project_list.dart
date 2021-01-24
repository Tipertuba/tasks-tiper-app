import 'package:flutter/material.dart';
import 'package:tiperapp/models/project.dart';
import 'package:tiperapp/screens/project_form.dart';
import 'package:uuid/uuid.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: ListView(
        children: [
          ProjectItem(),
          ProjectItem(),
          ProjectItem(),
          ProjectItem(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectFormContainer(Project(0, ""))));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  const ProjectItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(),
        title: Text('A project'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
