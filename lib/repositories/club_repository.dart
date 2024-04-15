import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:uuid/uuid.dart';

class ClubRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const ClubRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<List<ClubModel>> getClubList({
    String? clubId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = await firebaseFirestore
          .collection('clubs')
          .orderBy('createAt', descending: true);
      if(clubId != null){
        query = query.where('clubid', isEqualTo: clubId);
      }
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      await firebaseFirestore.collection('clubs').doc(clubId).get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get();
        ClubModel userModel = ClubModel.fromMap(writerSnapshot.data()!);
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
  Future<ClubModel?> uploadClub({
    required List<String> files,
    required String clubName,
    required String professorName,
    required String presidentName,
    required String call,
    required String shortComment,
    required String fullComment,
    required String clubType,
    required String uid,

  }) async {
    List<String> profileImageUrl = [];
    try {
      String clubId = Uuid().v1();
      DocumentReference<Map<String, dynamic>> feedDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);

      //동아리등록했을 떄 동작
      Reference ref = firebaseStorage.ref().child('clubs').child(clubId);

      profileImageUrl = await Future.wait(files.map((e) async {
        //파일이름을 Uuid
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
  void _deleteImage(List<String> profileImageUrl) {
    profileImageUrl.forEach((element) async {
      await firebaseStorage.refFromURL(element).delete();
    });
  }
}

