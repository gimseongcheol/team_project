import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<ClubModel> updateClub({
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
    required String clubId,
  }) async {
    List<String> profileImageUrl = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      // Firestore document references
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid); // Access user information

      // Firestorage reference
      Reference ref = firebaseStorage.ref().child('clubs').child(clubId);

      // Get existing club document
      DocumentSnapshot<Map<String, dynamic>> clubSnapshot = await clubDocRef.get();
      if (!clubSnapshot.exists) {
        throw CustomException(code: 'NotFound', message: 'Club not found');
      }

      // Get existing profile image URLs
      List<String> existingProfileImageUrls = List<String>.from(clubSnapshot.data()!['profileImageUrl']);

      // Delete existing profile images
      for (String url in existingProfileImageUrls) {
        await firebaseStorage.refFromURL(url).delete();
      }

      // Upload new profile images and get their URLs
      profileImageUrl = await Future.wait(files.map((e) async {
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL();
      }).toList());

      // Get user information
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      // Update the club document
      batch.update(clubDocRef, {
        'clubName': clubName,
        'clubType': clubType,
        'presidentName': presidentName,
        'professorName': professorName,
        'call': call,
        'shortComment': shortComment,
        'fullComment': fullComment,
        'profileImageUrl': profileImageUrl,
        'depart': depart,
      });

      batch.update(userDocRef, {
        'clubCount': FieldValue.increment(1),
      });

      // Commit the batch
      await batch.commit();

      // Return the updated club model
      ClubModel clubModel = ClubModel.fromMap({
        'uid': uid,
        'clubId': clubId,
        'clubName': clubName,
        'clubType': clubType,
        'writer': userModel,
        'createAt': clubSnapshot.data()!['createAt'], // Maintain existing createAt
        'presidentName': presidentName,
        'professorName': professorName,
        'call': call,
        'shortComment': shortComment,
        'fullComment': fullComment,
        'profileImageUrl': profileImageUrl,
        'commentCount': clubSnapshot.data()!['commentCount'] ?? 0, // Maintain existing commentCount
        'feedCount': clubSnapshot.data()!['feedCount'] ?? 0, // Maintain existing feedCount
        'noticeCount': clubSnapshot.data()!['noticeCount'] ?? 0, // Maintain existing noticeCount
        'depart': depart,
        'likes': clubSnapshot.data()!['likes'] ?? [],
        'likeCount': clubSnapshot.data()!['likeCount'] ?? 0,
        'reports': clubSnapshot.data()!['reports'] ?? [],
        'reportCount': clubSnapshot.data()!['reportCount'] ?? 0,
      });

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

  Future<void> cancelLike({
    required ClubModel clubModel,
}) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference clubDocRef = FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubModel.clubId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot clubSnapshot = await transaction.get(clubDocRef);

        if (!clubSnapshot.exists) {
          throw Exception("해당 동아리가 존재하지 않습니다!");
        }

        List<dynamic> likes = clubSnapshot['likes'];
        int likeCount = clubSnapshot['likeCount'];

        if (likes.contains(currentUserId)) {
          transaction.update(clubDocRef, {
            'likes': FieldValue.arrayRemove([currentUserId]),
            'likeCount': likeCount - 1,
          });
        }
      });
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

  Future<void> deleteClub({
    required ClubModel clubModel,
  }) async {
    try {
      WriteBatch batch = firebaseFirestore.batch();
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubModel.clubId);
      DocumentReference<Map<String, dynamic>> writerDocRef =
      firebaseFirestore.collection('users').doc(clubModel.uid);

      // 해당 게시물에 좋아요를 누른 users 문서의 likes 필드에서 feedId 삭제
      List<String> likes = await clubDocRef
          .get()
          .then((value) => List<String>.from(value.data()!['likes']));

      likes.forEach((uid) {
        batch.update(firebaseFirestore.collection('users').doc(uid), {
          'likes': FieldValue.arrayRemove([clubModel.clubId]),
        });
      });
      // 해당 게시물에 좋아요를 누른 users 문서의 likes 필드에서 feedId 삭제
      List<String> reports = await clubDocRef
          .get()
          .then((value) => List<String>.from(value.data()!['reports']));

      reports.forEach((uid) {
        batch.update(firebaseFirestore.collection('users').doc(uid), {
          'reports': FieldValue.arrayRemove([clubModel.clubId]),
        });
      });

      QuerySnapshot<Map<String, dynamic>> feedQuerySnapshot =
      await clubDocRef.collection('feeds').get();
      for (var doc in feedQuerySnapshot.docs) {
        batch.delete(doc.reference);
      }
      QuerySnapshot<Map<String, dynamic>> noticeQuerySnapshot =
      await clubDocRef.collection('notices').get();
      for (var doc in noticeQuerySnapshot.docs) {
        batch.delete(doc.reference);
      }
      // 해당 게시물의 comments 컬렉션의 docs 를 삭제
      QuerySnapshot<Map<String, dynamic>> commentQuerySnapshot =
      await clubDocRef.collection('comments').get();
      for (var doc in commentQuerySnapshot.docs) {
        batch.delete(doc.reference);
      }

      // feeds 컬렉션에서 문서 삭제
      batch.delete(clubDocRef);

      // 게시물 작성자의 users 문서에서 feedCount 1 감소
      batch.update(writerDocRef, {
        'clubCount': FieldValue.increment(-1),
      });

      // storage 의 이미지 삭제
      clubModel.profileImageUrl.forEach((element) async {
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
  Future<ClubModel> reportClub({
    required String clubId,
    required List<String> clubReports,
    required String uid,
    required List<String> userReports,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);

      // 게시물을 좋아하는 유저 목록에 uid 가 포함되어 있는지 확인
      // 포함되어 있다면 좋아요 취소
      // 게시물의 likes 필드에서 uid 삭제
      // 게시물의 likeCount 를 1 감소

      // 유저가 좋아하는 게시물 목록에 feedId 가 포함되어 있는지 확인
      // 포함되어 있다면 좋아요 취소
      // 유저의 likes 필드에서 feedId 삭제
      await firebaseFirestore.runTransaction((transaction) async {
        bool isClubContains = clubReports.contains(uid);

        transaction.update(clubDocRef, {
          'reports': isClubContains
              ? FieldValue.arrayRemove([uid])
              : FieldValue.arrayUnion([uid]),
          'reportCount': isClubContains
              ? FieldValue.increment(-1)
              : FieldValue.increment(1),
        });

        transaction.update(userDocRef, {
          'reports': userReports.contains(clubId)
              ? FieldValue.arrayRemove([clubId])
              : FieldValue.arrayUnion([clubId]),
        });
      });

      Map<String, dynamic> clubMapData =
      await clubDocRef.get().then((value) => value.data()!);

      DocumentReference<Map<String, dynamic>> writerDocRef =
      clubMapData['writer'];
      Map<String, dynamic> userMapData =
      await writerDocRef.get().then((value) => value.data()!);
      UserModel userModel = UserModel.fromMap(userMapData);
      clubMapData['writer'] = userModel;
      return ClubModel.fromMap(clubMapData);
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

  Future<ClubModel> likeClub({
    required String clubId,
    required List<String> clubLikes,
    required String uid,
    required List<String> userLikes,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> userDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);

      // 게시물을 좋아하는 유저 목록에 uid 가 포함되어 있는지 확인
      // 포함되어 있다면 좋아요 취소
      // 게시물의 likes 필드에서 uid 삭제
      // 게시물의 likeCount 를 1 감소

      // 유저가 좋아하는 게시물 목록에 feedId 가 포함되어 있는지 확인
      // 포함되어 있다면 좋아요 취소
      // 유저의 likes 필드에서 feedId 삭제
      await firebaseFirestore.runTransaction((transaction) async {
        bool isClubContains = clubLikes.contains(uid);

        transaction.update(clubDocRef, {
          'likes': isClubContains
              ? FieldValue.arrayRemove([uid])
              : FieldValue.arrayUnion([uid]),
          'likeCount': isClubContains
              ? FieldValue.increment(-1)
              : FieldValue.increment(1),
        });

        transaction.update(userDocRef, {
          'likes': userLikes.contains(clubId)
              ? FieldValue.arrayRemove([clubId])
              : FieldValue.arrayUnion([clubId]),
        });
      });

      Map<String, dynamic> clubMapData =
      await clubDocRef.get().then((value) => value.data()!);

      DocumentReference<Map<String, dynamic>> writerDocRef =
      clubMapData['writer'];
      Map<String, dynamic> userMapData =
      await writerDocRef.get().then((value) => value.data()!);
      UserModel userModel = UserModel.fromMap(userMapData);
      clubMapData['writer'] = userModel;
      return ClubModel.fromMap(clubMapData);
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
        'feedCount': 0,
        'noticeCount': 0,
        'depart': depart,
        'likes': [],
        'likeCount': 0,
        'reports': [],
        'reportCount': 0,
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
