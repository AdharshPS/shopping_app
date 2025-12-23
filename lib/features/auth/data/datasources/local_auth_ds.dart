import 'package:hive/hive.dart';
import 'package:shopping_app/features/auth/data/model/auth_user_model.dart';

class LocalAuthDs {
  final Box<AuthUserModel> box;

  LocalAuthDs(this.box);

  Future<void> saveUser(AuthUserModel user) async {
    await box.put('user', user);
  }

  AuthUserModel? getUser() {
    final model = box.get('user');
    return model;
  }

  Future<void> clear() async {
    await box.delete('user');
  }
}
