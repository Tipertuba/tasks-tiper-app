import 'package:flutter/material.dart';
import 'package:tiperapp/components/theme.dart';
import 'package:tiperapp/screens/dashboard.dart';

void main() {
  runApp(TiperApp());
}

class TiperApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: tiperAppTheme,
      home: Dashboard(),
    );
  }
}