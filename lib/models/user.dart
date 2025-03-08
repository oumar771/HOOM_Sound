// lib/models/user.dart

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? 'Utilisateur Inconnu',
      profileImageUrl: json['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'profile_image': profileImageUrl,
    };
  }
}
