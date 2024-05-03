import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ClubRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const ClubRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<List<ClubModel>> getClubList({
    String? uid,
  }) async {
    try {
      // QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
      //     .collection('feeds')
      //     .where('uid', isEqualTo: uid)
      //     .orderBy('createAt', descending: true)
      //     .get();
      Query<Map<String, dynamic>> query = await firebaseFirestore
          .collection('clubs')
          .orderBy('createAt', descending: true);
      if (uid != null) {
        query = query.where('uid', isEqualTo: uid);
      }
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
            await writerDocRef.get();
        UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
        data['writer'] = userModel;
        return ClubModel.fromMap(data);
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

  Future<ClubModel> uploadClub({
    required List<String> files,
    required String clubName,
    required String professorName,
    required String presidentName,
    required String shortComment,
    required String fullComment,
    required String clubType,
    required String depart,
    required String call,
    required String uid,
  }) async {
    List<String> profileImageUrl = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String clubId = Uuid().v1();
      //firestore 문서 참조
      DocumentReference<Map<String, dynamic>> clubDocRef =
          firebaseFirestore.collection('clubs').doc(clubId);

      DocumentReference<Map<String, dynamic>> userDocRef =
          firebaseFirestore.collection('users').doc(uid); //해당 유저의 정보를 접근
      //firestorage 참조
      Reference ref = firebaseStorage.ref().child('clubs').child(clubId);

      profileImageUrl = await Future.wait(files.map((e) async {
        //파일이름을 Uuid
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      ClubModel clubModel = ClubModel.fromMap({
        'uid': uid,
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

      batch.update(userDocRef, {
        'clubCount': FieldValue.increment(1),
      });

      batch.commit();
      return clubModel;
    } on FirebaseException catch (e) {
      _deleteImage(profileImageUrl);
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      _deleteImage(profileImageUrl);
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
