class User {
  String id;
  String username;
  String fullName;
  String email;
  bool emailVisibility;
  bool verified;
  String role;
  String picture;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.emailVisibility,
    required this.verified,
    required this.role,
    required this.picture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
      email: json['email'],
      emailVisibility: json['emailVisibility'],
      verified: json['verified'],
      role: json['role'],
      picture: json['picture'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}