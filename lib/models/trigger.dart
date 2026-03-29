class Trigger {
  final String id;
  final String name;

  Trigger({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Trigger.fromJson(Map<String, dynamic> json) =>
      Trigger(id: json['id'], name: json['name']);
}
