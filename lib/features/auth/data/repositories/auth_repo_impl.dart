import 'package:shopping_app/features/auth/data/datasources/google_auth_ds.dart';
import 'package:shopping_app/features/auth/data/datasources/local_auth_ds.dart';
import 'package:shopping_app/features/auth/data/model/auth_user_model.dart';
import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final GoogleAuthDs googleAuthDs;
  final LocalAuthDs localAuthDs;
  AuthRepoImpl({required this.googleAuthDs, required this.localAuthDs});

  @override
  Future<AuthUserEntity> signInWithGoogle() async {
    final user = await googleAuthDs.signIn();
    return user.toEntity();
  }

  @override
  Future<void> logout() async {
    await googleAuthDs.signOut();
    await localAuthDs.clear();
  }

  @override
  Future<AuthUserEntity?> getSavedUser() async {
    final model = localAuthDs.getUser();
    return model?.toEntity();
  }

  @override
  Future<void> saveUser(AuthUserEntity user) async {
    final model = AuthUserModel.fromEntity(user);
    await localAuthDs.saveUser(model);
  }
}
