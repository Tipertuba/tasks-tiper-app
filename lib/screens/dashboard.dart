import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Wrap(
        children: [
          _FeatureItem("Habit", Icons.loop, onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
          _FeatureItem("Tasks", Icons.check_box_outline_blank,
              onClick: null),
        ],
      ),
    );
  }

  void _showHabits(BuildContext context) {
    print("load habits page");
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(this.name, this.icon, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: 24.0,
              ),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
