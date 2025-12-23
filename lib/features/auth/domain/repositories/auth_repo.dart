import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';

abstract class AuthRepo {
  Future<AuthUserEntity> signInWithGoogle();
  Future<void> saveUser(AuthUserEntity user);
  Future<AuthUserEntity?> getSavedUser();
  Future<void> logout();
}
