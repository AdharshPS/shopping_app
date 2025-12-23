import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/features/auth/data/model/auth_user_model.dart';

class GoogleAuthDs {
  final GoogleSignIn _signIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _signIn.initialize(
      serverClientId:
          '480836142478-a6rd2t05vcj4h5ofv6vhdhc1qfun8quj.apps.googleusercontent.com',
    );
    _initialized = true;
  }

  Future<AuthUserModel> signIn() async {
    await _init();
    final user = await _signIn.authenticate();
    return AuthUserModel(email: user.email, name: user.displayName ?? '');
  }

  Future<void> signOut() async {
    await _signIn.signOut();
  }
}
