import 'package:hive/hive.dart';
import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
part 'auth_user_model.g.dart';

@HiveType(typeId: 3)
class AuthUserModel {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String name;

  AuthUserModel({required this.email, required this.name});

  AuthUserEntity toEntity() {
    return AuthUserEntity(email: email, name: name);
  }

  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(email: entity.email, name: entity.name);
  }
}
