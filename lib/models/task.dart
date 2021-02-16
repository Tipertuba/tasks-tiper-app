class Task {
  final int id;
  final String name;
  final bool completed;

  Task(this.id, this.name, this.completed);

  @override
  String toString() {}

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'completed': completed};
}
