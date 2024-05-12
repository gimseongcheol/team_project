import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:uuid/uuid.dart';

class FeedRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const FeedRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<List<FeedModel>> getFeedList({
    String? clubId,
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
          .collection('feeds')
          .orderBy('createAt', descending: true);
      // uid 가 null 이 아닐 경우(특정 유저의 피드를 가져올 경우) query에 조건 추가
      if(clubId != null){
        query = query.where('clubId', isEqualTo: clubId);
      }
      // query 를 실행하여 snapshot 생성
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get();
        ClubModel clubModel = ClubModel.fromMap(writerSnapshot.data()!);
        data['writer'] = clubModel;
        return FeedModel.fromMap(data);
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

  Future<FeedModel> uploadFeed({
    required List<String> files,
    required String desc,
    required String title,
    required String clubId,
  }) async {
    List<String> imageUrls = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String feedId = Uuid().v1();

      //firestore 문서 참조
      DocumentReference<Map<String, dynamic>> feedDocRef =
      firebaseFirestore.collection('feeds').doc(feedId);

      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      //firestorage 참조
      Reference ref = firebaseStorage.ref().child('feeds').child(feedId);

      imageUrls = await Future.wait(files.map((e) async {
        //파일이름을 Uuid
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
      await clubDocRef.get();
      ClubModel clubModel = ClubModel.fromMap(clubSnapshot.data()!);

      FeedModel feedModel = FeedModel.fromMap({
        'clubId': clubId,
        'feedId': feedId,
        'desc': desc,
        'imageUrls': imageUrls,
        'likes': [],
        'likeCount': 0,
        'commentCount': 0,
        'createAt': Timestamp.now(),
        'writer': clubModel,
      });

      //await feedDocRef.set(feedModel.toMap(userDocRef: userDocRef));
      batch.set(feedDocRef, feedModel.toMap(clubDocRef: clubDocRef));

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
      //batch.update(clubDocRef, {
      //  'feedCount': FieldValue.increment(1),
      //});

      batch.commit();
      return feedModel;
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