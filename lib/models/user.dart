class User {
  final String email;
  final String username;

  User({required this.email, required this.username});

  Map<String, dynamic> toJson() => {'email': email, 'username': username};
  factory User.fromJson(Map<String, dynamic> json) =>
      User(email: json['email'], username: json['username']);
}
