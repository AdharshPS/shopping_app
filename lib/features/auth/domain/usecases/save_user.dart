import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class SaveUser {
  final AuthRepo repo;
  SaveUser(this.repo);
  Future<void> call(AuthUserEntity user) => repo.saveUser(user);
}
