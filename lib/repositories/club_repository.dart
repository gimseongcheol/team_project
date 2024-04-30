import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ClubRepository {
  final FirebaseStorage firebaseStorage; // FirebaseStorage 객체를 저장하기 위한 final 변수
  final FirebaseFirestore firebaseFirestore; // FirebaseFirestore 객체를 저장하기 위한 final 변수

  const ClubRepository({
    required this.firebaseStorage, // 필수 파라미터로 FirebaseStorage 객체를 받음
    required this.firebaseFirestore,// 필수 파라미터로 FirebaseFirestore 객체를 받음
  });

  Future<List<ClubModel>> getClubList({
    String? clubId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = await firebaseFirestore
          .collection('clubs')
          .orderBy('createAt', descending: true); // 'clubs' 컬렉션에서 createAt 필드를 기준으로 내림차순으로 정렬된 Query를 생성합니다.
      if(clubId != null){
        query = query.where('clubid', isEqualTo: clubId); // clubId가 제공된 경우 해당 clubId와 일치하는 동아리만 가져오도록 Query를 필터링
      }
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get(); // Query를 실행하여 결과를 얻습니다.

      await firebaseFirestore.collection('clubs').doc(clubId).get(); // clubId에 해당하는 동아리 정보를 가져옵니다.
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data(); // 각 동아리의 데이터를 가져옵니다.
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer']; // 작성자 정보를 가리키는 DocumentReference를 가져옵니다.
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get(); // 작성자 정보를 가져옵니다.
        ClubModel userModel = ClubModel.fromMap(writerSnapshot.data()!); // 작성자 정보를 ClubModel 객체로 변환합니다.
        data['writer'] = userModel; // 동아리 데이터에 작성자 정보를 추가합니다.
        return ClubModel.fromMap(data); // ClubModel 객체를 생성하여 반환합니다.
      }).toList());
    } on FirebaseException catch (e) { // FirebaseException이 발생한 경우
      throw CustomException( // CustomException을 던집니다.
        code: e.code, // 예외 코드를 설정합니다.
        message: e.message!, // 예외 메시지를 설정합니다.
      );
    } catch (e) { // 기타 예외가 발생한 경우
      throw CustomException( // CustomException을 던집니다.
        code: 'Exception', // 예외 코드를 설정합니다.
        message: e.toString(), // 예외 메시지를 설정합니다.
      );
    }
  }
  Future<ClubModel?> uploadClub({
    required List<String> files,
    required String clubName,
    required String professorName,
    required String presidentName,
    required String call,
    required String shortComment,
    required String fullComment,
    required String clubType,
    required String depart,
    required String uid,
  }) async {
    List<String> profileImageUrl = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String clubId = Uuid().v1();
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);

      Reference ref = firebaseStorage.ref().child('clubs').child(clubId);

      profileImageUrl = await Future.wait(files.map((e) async {
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot =
        await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      ClubModel clubModel = ClubModel.fromMap({
        'clubId': clubId,
        'clubName': clubName,
        'clubType': clubType,
        'writer': userModel,
        'createAt': Timestamp.now(),
        'presidentName': presidentName,
        'professorName': professorName,
        'call': call,
        'shortComment': shortComment,
        'fullComment': fullComment,
        'profileImageUrl': profileImageUrl,
        'commentCount': 0,
        'noticeCount': 0,
        'depart': depart,
        'likes': [],
      });

      batch.set(clubDocRef, clubModel.toMap(userDocRef: userDocRef));
      batch.update(userDocRef, {'clubCount': FieldValue.increment(1)});

      await batch.commit(); // 모든 쓰기 작업이 완료될 때까지 대기합니다.
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
  void _deleteImage(List<String> profileImageUrl) {
    profileImageUrl.forEach((element) async {
      await firebaseStorage.refFromURL(element).delete(); // Firebase Storage에서 이미지를 삭제합니다.
    });
  }
}

