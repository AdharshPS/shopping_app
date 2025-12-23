import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:shopping_app/features/dashboard/presentation/screens/bottom_navigation_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight * .4,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      constraints: constraints,
                      signIn: () async {
                        await context.read<AuthProvider>().login();
                        if (!context.mounted) return;
                        if (context.read<AuthProvider>().loginedUser != null) {
                          context.read<AuthProvider>().saveUser(
                            context.read<AuthProvider>().loginedUser!,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BoxConstraints constraints,
    Function()? signIn,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: signIn,
        child: Container(
          height: 80,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            'Login with Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
