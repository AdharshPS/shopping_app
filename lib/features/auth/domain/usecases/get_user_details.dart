import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class GetUserDetails {
  final AuthRepo repo;
  GetUserDetails(this.repo);
  Future<AuthUserEntity?> call() => repo.getSavedUser();
}
