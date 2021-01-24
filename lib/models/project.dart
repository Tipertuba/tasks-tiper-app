

class Project {
  final int id;
  final String name;

  Project(this.id, this.name);

  @override
  String toString() {
    return 'Project{id: $id, name: $name}';
  }

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
