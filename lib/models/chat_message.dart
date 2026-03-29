class ChatMessage {
  final String text;
  final String sender; // 'user' or 'bot'
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'sender': sender,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'],
    sender: json['sender'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
