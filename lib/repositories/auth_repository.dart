import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:mime/mime.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const AuthRepository(
      {required this.firebaseAuth,
      required this.firebaseStorage,
      required this.firebaseFirestore});

  Future<void> signOut() async {
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

    await firebaseAuth.signOut();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      bool isVerified = userCredential.user!.emailVerified;
      if (!isVerified) {
        await userCredential.user!.sendEmailVerification();
        await firebaseAuth.signOut();
        throw CustomException(
          code: 'Exception',
          message: '인증되지 않은 이메일',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String userid,
    required String name,
    required String password,
    required Uint8List? profileImage,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              //회원가입동시에 로그인
              email: email,
              password: password);
      String uid = userCredential.user!.uid;
      //인증 메일
      await userCredential.user!.sendEmailVerification();
      //인증메일을 보낸후
      //downloadURL이 null이 경우 프로필 등록x
      String? downloadURL = null;
      //프로필 이미지가 null이 아님을 검증
      if (profileImage != null) {
        // mime 패키지의 lookupMimeType 함수를 사용해서 file 의 mimeType 을 String 으로 받음
        // lookupMimeType 의 첫 번째 인자값은 파일의 경로를 전달, 선택 인자값 headerBytes 에 파일의 데이터를 int 로 갖고 있는 List 를 전달
        // 원래 lookupMimeType 함수는 파일의 경로에 존재하는 파일의 확장자로부터 mimeType 을 특정하지만, headerBytes 에 파일 데이터가 전달되면
        // 파일 데이터에서 magic-number(파일의 유형에 대한 정보를 갖고 있는 데이터)로 mimeType 을 특정함
        String? mimeType = lookupMimeType('', headerBytes: profileImage);
        SettableMetadata metadata = SettableMetadata(contentType: mimeType);

        //프로필사진을 등록했을 때 동작
        Reference ref = firebaseStorage.ref().child('profile').child(uid);
        TaskSnapshot snapshot = await ref.putData(profileImage, metadata);
        //사진 접근 경로 지정
        //uploadTask 저장이 완료 되지 않았는데 이미지파일의 경로를 가져올려고 하니 오류날 수 있음
        //TaskSnapshot으로 바꾸고 await추가
        downloadURL = await snapshot.ref.getDownloadURL();
      }
      //해당 유저정보를 가져옴
      await firebaseFirestore.collection('users').doc(uid).set({
        'uid': uid,
        'userid': userid,
        'email': email,
        'name': name,
        'profileImage': downloadURL,
        'feedCount': 0,
        'likes': [],
        'followers': [],
        'following': [],
      });
      firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }

  Future<void> updateUserInfo({
    required String name,
    required String studentID,
    required Uint8List? profileImage,
  }) async {
    try {
      // Get the current user
      User? currentUser = firebaseAuth.currentUser;

      // Check if the user is authenticated
      if (currentUser == null || currentUser.isAnonymous) {
        throw CustomException(
          code: "인증되지 않은 사용자",
          message: '접근 불가능한 경로입니다.',
        );
      }

      // Update the user's display name if name is provided
      if (name.isNotEmpty) {
        await currentUser.updateDisplayName(name);
      }

      // Implement the logic to update student ID
      // (You may need to store this information in your database)

      // Implement the logic to update profile image
      // (You may need to upload the new profile image to a storage service like Firebase Storage)

      // Optionally, update the user's profile image
      // if (profileImage != null) {
      //   // Implement the logic to upload the new profile image
      // }
    } catch (e) {
      // Handle any errors that occur during the update process
      throw CustomException(
        code: "Failed to update user information: $e",
        message: e.toString(),
      );
    }
  }
}
