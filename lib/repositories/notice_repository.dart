import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
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

  Future<NoticeModel> updateNotice({
    required List<String> files,
    required String desc,
    required String title,
    required String uid,
    required String clubId,
    required String noticeId,
  }) async {
    List<String> imageUrls = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      // Firestore document reference
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> noticeDocRef =
      clubDocRef.collection('notices').doc(noticeId);

      // Firestorage reference
      Reference ref = firebaseStorage.ref().child('notices').child(noticeId);
      // Get existing notice document
      DocumentSnapshot<Map<String, dynamic>> noticeSnapshot = await noticeDocRef.get();
      if (!noticeSnapshot.exists) {
        throw CustomException(code: 'NotFound', message: 'Notice not found');
      }

      // Get existing image URLs
      List<String> existingImageUrls = List<String>.from(noticeSnapshot.data()!['imageUrls']);

      // Delete existing images
      for (String url in existingImageUrls) {
        await firebaseStorage.refFromURL(url).delete();
      }

      // Upload new images and get their URLs
      imageUrls = await Future.wait(files.map((e) async {
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      // Get user information
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      // Update the notice document
      batch.update(noticeDocRef, {
        'title': title,
        'desc': desc,
        'imageUrls': imageUrls,
      });

      // Commit the batch
      await batch.commit();

      // Return the updated notice model
      NoticeModel noticeModel = NoticeModel.fromMap({
        'uid': uid,
        'clubId': clubId,
        'noticeId': noticeId,
        'desc': desc,
        'title': title,
        'imageUrls': imageUrls,
        'likes': [], // Ensure to maintain existing likes if needed
        'likeCount': 0, // Ensure to maintain existing likeCount if needed
        'createAt': Timestamp.now(), // Ensure to maintain existing createAt if needed
        'writer': userModel,
      });

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
  Future<void> deleteNotice({
    required String clubId,
    required NoticeModel noticeModel,
  }) async {
    try {
      WriteBatch batch = firebaseFirestore.batch();
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      // 주어진 commentId에 해당하는 댓글을 삭제합니다.
      DocumentReference<Map<String, dynamic>> noticeDocRef =
      clubDocRef.collection('notices').doc(noticeModel.noticeId);

      // feeds 컬렉션에서 문서 삭제
      batch.delete(noticeDocRef);

      // 게시물 작성자의 users 문서에서 feedCount 1 감소
      batch.update(clubDocRef, {
        'noticeCount': FieldValue.increment(-1),
      });

      // storage 의 이미지 삭제
      noticeModel.imageUrls.forEach((element) async {
        await firebaseStorage.refFromURL(element).delete();
      });

      batch.commit();
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

  Future<List<NoticeModel>> getNoticeList({
    required String clubId,
  }) async {
    try {
      //QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
      //    .collection('clubs')
      //    .doc(clubId)
      //    .collection('comments')
      //    .orderBy('createdAt', descending: true)
      //    .get();
      Query<Map<String, dynamic>> query = await firebaseFirestore
          .collection('clubs')
          .doc(clubId)
          .collection('notices')
          .orderBy('createAt', descending: true);

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get();
        UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
        data['writer'] = userModel;
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
    required String desc,
    required String title,
    required String uid,
    required String clubId,
  }) async {
    List<String> imageUrls = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String noticeId = Uuid().v1();
      /*
       DocumentReference<Map<String, dynamic>> writerDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> commentDocRef =
      clubDocRef.collection('comments').doc(commentId);
       */
      //firestore 문서 참조
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> noticeDocRef =
      clubDocRef.collection('notices').doc(noticeId);
      //firestorage 참조
      Reference ref = firebaseStorage.ref().child('notices').child(noticeId);

      imageUrls = await Future.wait(files.map((e) async {
        //파일이름을 Uuid
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      NoticeModel noticeModel = NoticeModel.fromMap({
        'uid': uid,
        'clubId': clubId,
        'noticeId': noticeId,
        'desc': desc,
        'title': title,
        'imageUrls': imageUrls,
        'likes': [],
        'likeCount': 0,
        'createAt': Timestamp.now(),
        'writer': userModel,
      });

      batch.set(noticeDocRef, noticeModel.toMap(userDocRef: userDocRef));

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