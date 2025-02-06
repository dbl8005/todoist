class UserEntity {
  final String id;
  final String? email;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    this.email,
    required this.isEmailVerified,
  });
}
