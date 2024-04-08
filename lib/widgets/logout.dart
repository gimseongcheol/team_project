import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_project/screens/signin_screen.dart'; // 로그인 화면 파일을 임포트합니다.

Future<void> logoutAndNavigateToLoginScreen(BuildContext context) async {
  try {
    // 현재 사용자 정보 가져오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 익명 계정인 경우 삭제
      if (user.isAnonymous) {
        await user.delete();
        print('익명 계정 삭제 성공!');
      }
    }
  } catch (e) {
    print('익명 계정 삭제 실패: $e');
  }

  // 로그아웃 처리
  await FirebaseAuth.instance.signOut();

}
