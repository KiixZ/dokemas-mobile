class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final String? createdAt;
  final bool active; // UI placeholder if not returned from backend

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.createdAt,
    this.active = true,
  });

  String get avatarUrl {
    if (avatar == null || avatar!.isEmpty) {
      return 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop';
    }
    if (avatar!.startsWith('http')) {
      return avatar!.replaceFirst('http://', 'https://');
    }
    return 'https://porto-backend-dokemas.rryxja.easypanel.host/storage/$avatar';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      avatar: json['avatar'],
      createdAt: json['created_at'],
      active: true, // Default to true for now
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
    };
  }

  UserModel copyWith({bool? active}) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      avatar: avatar,
      createdAt: createdAt,
      active: active ?? this.active,
    );
  }
}
