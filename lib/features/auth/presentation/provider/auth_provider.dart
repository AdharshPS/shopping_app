import 'package:flutter/material.dart';
import 'package:shopping_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:shopping_app/features/auth/domain/usecases/get_user_details.dart';
import 'package:shopping_app/features/auth/domain/usecases/logout.dart';
import 'package:shopping_app/features/auth/domain/usecases/save_user.dart';
import 'package:shopping_app/features/auth/domain/usecases/sign_in_with_google.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo repo;
  final SignInWithGoogle _signInWithGoogle;
  final Logout _logout;
  final SaveUser _saveUser;
  final GetUserDetails _getUserDetails;
  AuthProvider(this.repo)
    : _signInWithGoogle = SignInWithGoogle(repo),
      _logout = Logout(repo),
      _saveUser = SaveUser(repo),
      _getUserDetails = GetUserDetails(repo);

  AuthUserEntity? loginedUser;

  Future<void> login() async {
    loginedUser = await _signInWithGoogle();
    notifyListeners();
  }

  Future<void> logout() async {
    await _logout();
    loginedUser = await _getUserDetails();
    notifyListeners();
  }

  Future<void> saveUser(AuthUserEntity user) async {
    await _saveUser(user);
    notifyListeners();
  }

  Future<void> getUserDetails() async {
    loginedUser = await _getUserDetails();
    notifyListeners();
  }
}
