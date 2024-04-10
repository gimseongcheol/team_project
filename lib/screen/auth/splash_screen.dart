import 'package:flutter/material.dart';
import 'package:team_project/providers/auth/auth_state.dart';
import 'package:team_project/main.dart';
import 'package:team_project/screen/auth/signin_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().authStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => authStatus == AuthStatus.authenticated
              ? MainForm()//MainScreen()
              : SigninScreen(),
        ),
        (route) => route.isFirst,
      );
    });
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
