class JournalEntry {
  final String id;
  final DateTime date;
  final String content;
  final String title;

  JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'content': content,
    'title': title,
  };
  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    date: DateTime.parse(json['date']),
    content: json['content'],
    title: json['title'],
  );
}
