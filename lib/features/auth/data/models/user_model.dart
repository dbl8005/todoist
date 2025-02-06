import 'package:todoist/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends UserEntity {
  UserModel({
    required String id,
    String? email,
    required bool isEmailVerified,
  }) : super(
          id: id,
          email: email,
          isEmailVerified: isEmailVerified,
        );
  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      isEmailVerified: firebaseUser.emailVerified,
    );
  }
}
