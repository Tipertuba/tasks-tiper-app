import 'package:flutter/material.dart';

class ProjectForm extends StatefulWidget {
  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New project'),
      ),
      body: Container(
        child: Text('hello'),
      ),
    );
  }
}
