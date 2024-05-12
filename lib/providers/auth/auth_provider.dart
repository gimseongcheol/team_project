import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mime/mime.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/auth/auth_state.dart';
import 'package:team_project/repositories/auth_repository.dart';
import 'package:state_notifier/state_notifier.dart';
class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.init());

  @override
  void update(Locator watch) {
    final user = watch<User?>();
    // 회원가입시 메인화면 갔다가 로그인화면 페이지 이동 오류 수정
    if (user != null && !user.emailVerified) {
      return;
    }
    if (user == null && state.authStatus == AuthStatus.unauthenticated) {
      return;
    }

    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } else {
      state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> signOut() async {
    await read<AuthRepository>().signOut();
  }

  Future<void> signUp({
    required String userid,
    required String email,
    required String name,
    required String password,
    required Uint8List? profileImage,
  }) async {
    try {
      await read<AuthRepository>().signUp(
        email: email,
        userid: userid,
        name: name,
        password: password,
        profileImage: profileImage,
      );
    } on CustomException catch (_) {
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await read<AuthRepository>().signIn(
        email: email,
        password: password,
      );
    } on CustomException catch (_) {
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInAnonymously();
      // 익명 로그인 성공 시
      print('익명 로그인 성공!');
      print('User ID: ${userCredential.user!.uid}');
      // AuthState 업데이트
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } catch (e) {
      // 익명 로그인 실패 시
      print('익명 로그인 실패: $e');
    }
  }
  // // 현재 로그인한 사용자의 UID를 가져오는 메서드
  // String getCurrentUserId() {
  //   return FirebaseAuth.instance.currentUser?.uid ?? '';
  // }

//   // Firebase 데이터베이스에서 사용자 정보를 업데이트하는 메서드
//   Future<void> updateFirebaseUserInfo({
//     required String name,
//     required String userid,
//     Uint8List? profileImage,
// }) async {
//     try {
//       // 현재 로그인한 사용자의 UID를 가져옵니다.
//       String uid = getCurrentUserId();
//
//       // Firestore 컬렉션 참조
//       CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//       // 해당 사용자의 문서를 가져와서 업데이트합니다.
//       await users.doc(uid).update({
//         'name': name, // 변경할 사용자 이름
//         'userid': userid, // 변경할 학번
//         'profileImage': profileImage,
//       });
//     } catch (e) {
//       // 업데이트 과정에서 오류가 발생하면 CustomException을 throw하여 예외 처리합니다.
//       throw CustomException(code: '에러', message: '사용자 정보를 업데이트하는 도중 오류가 발생했습니다.');
//     }
//   }

  // Future<void> updateUserInfo({
  //   required String name,
  //   required String studentID,
  //   required Uint8List? profileImage,
  // }) async {
  //   try {
  //     // Call the repository method to update user info
  //     await read<AuthRepository>().updateUserInfo(
  //       name: name,
  //       studentID: studentID,
  //       profileImage: profileImage,
  //     );
  //     // Optionally, update local state if needed
  //   } on CustomException catch (_) {
  //     rethrow;
  //   }
}
/*Future<void> deleteAnonymousAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        await user.delete();
        // 익명 계정 삭제 성공 시
        print('익명 계정 삭제 성공!');
      }
    } catch (e) {
      // 익명 계정 삭제 실패 시
      print('익명 계정 삭제 실패: $e');
    }
  }*/
