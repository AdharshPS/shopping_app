import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class Logout {
  final AuthRepo repo;
  Logout(this.repo);
  Future<void> call() => repo.logout();
}
