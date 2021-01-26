class Task {
  final int id;
  final String name;

  Task(this.id, this.name);

  @override
  String toString() {}

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
