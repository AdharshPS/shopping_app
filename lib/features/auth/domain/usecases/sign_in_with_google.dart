import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class SignInWithGoogle {
  final AuthRepo repo;

  SignInWithGoogle(this.repo);

  Future<AuthUserEntity> call() {
    return repo.signInWithGoogle();
  }
}
