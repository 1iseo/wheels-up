class User {
  final int id;
  final String fullName;
  final String email;
  final String username;
  final String role;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.role,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class User2 {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String role;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? picture;

  User2({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.role,
    this.picture,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User2.fromJson(Map<String, dynamic> json) {
    return User2(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      picture: json['picture'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CreateUserRequest {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final bool? emailVisibility;
  final String passwordConfirm;
  final String role;

  CreateUserRequest({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    this.emailVisibility,
    required this.passwordConfirm,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'username': username,
      'password': password,
      'emailVisibility': emailVisibility,
      'passwordConfirm': passwordConfirm,
      'role': role,
    };
  }
}

class UpdateProfileRequest {
  final String? password;
  final String? passwordConfirm;
  final String? oldPassword;
  final String? username;
  final String? fullName;
  final String? email;
  final bool? emailVisibility;
  final bool? verified;
  final String? role;

  UpdateProfileRequest({
    this.password,
    this.passwordConfirm,
    this.oldPassword,
    this.username,
    this.fullName,
    this.email,
    this.emailVisibility,
    this.verified,
    this.role,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (password != null) data['password'] = password;
    if (passwordConfirm != null) data['passwordConfirm'] = passwordConfirm;
    if (oldPassword != null) data['oldPassword'] = oldPassword;
    if (username != null) data['username'] = username;
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (emailVisibility != null) data['emailVisibility'] = emailVisibility;
    if (verified != null) data['verified'] = verified;
    if (role != null) data['role'] = role;
    
    return data;
  }
}
