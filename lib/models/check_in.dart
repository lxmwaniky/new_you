class CheckIn {
  final DateTime date;
  final bool completed;

  CheckIn({required this.date, required this.completed});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'completed': completed,
  };
  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      CheckIn(date: DateTime.parse(json['date']), completed: json['completed']);
}
