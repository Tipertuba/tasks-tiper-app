import 'package:flutter/material.dart';
import 'package:tiperapp/screens/project_form.dart';

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectForm()));
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
