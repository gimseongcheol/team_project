import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/providers/auth/auth_provider.dart' as myAuthProvider;
import 'package:team_project/screen/auth/signup_screen.dart';
import 'package:team_project/widgets/logout.dart';

Future<void> SignUpButtonWidget(BuildContext context) async {
  await context.read<myAuthProvider.AuthProvider>().signOut();
  // 로그인 화면 대신 회원가입 화면으로 이동
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignupScreen()),
  );
}
