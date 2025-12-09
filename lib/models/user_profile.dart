class UserProfile {
  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? description;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.description,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      username: map['username'],
      fullName: map['full_name'],
      avatarUrl: map['avatar_url'],
      description: map['description'],
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'description': description,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
