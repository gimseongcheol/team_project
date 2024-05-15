import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:uuid/uuid.dart';

class NoticeRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const NoticeRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<List<NoticeModel>> getNoticeList({
    String? uid,
  }) async {
    try {
      // QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
      //     .collection('feeds')
      //     .where('uid', isEqualTo: uid)
      //     .orderBy('createAt', descending: true)
      //     .get();
      // 새로운 코드
      // snapshot 을 생성하기 위한 query 생성
      Query<Map<String, dynamic>> query = await firebaseFirestore
          .collection('notices')
          .orderBy('createAt', descending: true);
      // uid 가 null 이 아닐 경우(특정 유저의 피드를 가져올 경우) query에 조건 추가
      if (uid != null) {
        query = query.where('uid', isEqualTo: uid);
      }
      // query 를 실행하여 snapshot 생성
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get();
        ClubModel clubModel = ClubModel.fromMap(writerSnapshot.data()!);
        data['writer'] = clubModel.clubName;
        return NoticeModel.fromMap(data);
      }).toList());
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

  Future<NoticeModel> uploadNotice({
    required List<String> files,
    required String title,
    required String desc,
    required String clubId,
  }) async {
    List<String> imageUrls = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String noticeId = Uuid().v1();

      //firestore 문서 참조
      DocumentReference<Map<String, dynamic>> noticeDocRef =
      firebaseFirestore.collection('notices').doc(noticeId);

      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      //firestorage 참조
      Reference ref = firebaseStorage.ref().child('notices').child(noticeId);

      imageUrls = await Future.wait(files.map((e) async {
        //파일이름을 Uuid
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
      await clubDocRef.get();
      ClubModel clubModel = ClubModel.fromMap(clubSnapshot.data()!);

      NoticeModel noticeModel = NoticeModel.fromMap({
        'clubId': clubId,
        'feedId': noticeId,
        'desc': desc,
        'imageUrls': imageUrls,
        'likes': [],
        'likeCount': 0,
        'commentCount': 0,
        'createAt': Timestamp.now(),
        'writer': clubModel,
      });

      //await feedDocRef.set(feedModel.toMap(userDocRef: userDocRef));
      batch.set(noticeDocRef, noticeModel.toMap(clubDocRef: clubDocRef));

      /*
    await feedDocRef.set({'uid': uid,
      'feedId': feedId,
      'desc': desc,
      'imageUrls': imageUrls,
      'likes': [],
      'likeCount': 0,
      'commentcount': 0,
      'createAt': Timestamp.now(),
      'writer': userDocref,}});
     */

      // await userDocRef.update({
      //   'feedCount': FieldValue.increment(1),
      // });
      batch.update(clubDocRef, {
        'noticeCount': FieldValue.increment(1),
      });

      batch.commit();
      return noticeModel;
    } on FirebaseException catch (e) {
      _deleteImage(imageUrls);
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      _deleteImage(imageUrls);
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }

  void _deleteImage(List<String> imageUrls) {
    imageUrls.forEach((element) async {
      await firebaseStorage.refFromURL(element).delete();
    });
  }
}