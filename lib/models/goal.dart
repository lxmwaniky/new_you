class Goal {
  final String id;
  final String title;
  final double progress;

  Goal({required this.id, required this.title, required this.progress});

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'progress': progress,
  };
  factory Goal.fromJson(Map<String, dynamic> json) =>
      Goal(id: json['id'], title: json['title'], progress: json['progress']);
}
