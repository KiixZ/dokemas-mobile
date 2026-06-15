/// Peran user di aplikasi.
enum UserRole { admin, user }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Admin',
        UserRole.user => 'User',
      };
}

/// Model akun pengguna (UI only, belum konek backend).
class AppUser {
  final String name;
  final String email;
  final UserRole role;
  final String joined; // mis. "Jan 2024"
  final bool active;

  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    required this.joined,
    this.active = true,
  });

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();

  AppUser copyWith({bool? active}) => AppUser(
        name: name,
        email: email,
        role: role,
        joined: joined,
        active: active ?? this.active,
      );
}

/// Data dummy kelola user.
const dummyUsers = [
  AppUser(
    name: 'Rifki Saputra',
    email: 'rifki@dokemas.id',
    role: UserRole.admin,
    joined: 'Jan 2024',
  ),
  AppUser(
    name: 'Siti Aminah',
    email: 'siti.aminah@gmail.com',
    role: UserRole.user,
    joined: 'Mar 2024',
  ),
  AppUser(
    name: 'Budi Santoso',
    email: 'budi.santoso@gmail.com',
    role: UserRole.user,
    joined: 'Apr 2024',
  ),
  AppUser(
    name: 'Deni Wijaya',
    email: 'deni.w@gmail.com',
    role: UserRole.user,
    joined: 'Jun 2024',
    active: false,
  ),
];
