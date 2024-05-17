import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';

class LikeRepository {
  final FirebaseFirestore firebaseFirestore;

  const LikeRepository({
    required this.firebaseFirestore,
  });

  Future<List<ClubModel>> getLikeList({
    required String uid,
    required int likeLength,
    String? clubId,
  }) async {
    try {
      Map<String, dynamic> userMapData = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.data()!);

      List<String> likes = List<String>.from(userMapData['likes']);

      if (clubId != null) {
        int startIdx = likes.indexWhere((element) => element == clubId) + 1;
        int endIdx = (startIdx + likeLength) > likes.length
            ? likes.length
            : startIdx + likeLength;
        likes = likes.sublist(startIdx, endIdx);
      } else {
        int endIdx = likes.length < likeLength ? likes.length : likeLength;
        likes = likes.sublist(0, endIdx);
      }

      List<ClubModel> likeList = await Future.wait(likes.map((clubId) async {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore.collection('clubs').doc(clubId).get();
        Map<String, dynamic> clubMapData = documentSnapshot.data()!;
        DocumentReference<Map<String, dynamic>> userDocRef =
        clubMapData['writer'];
        Map<String, dynamic> writerMapData =
        await userDocRef.get().then((value) => value.data()!);
        clubMapData['writer'] = UserModel.fromMap(writerMapData);
        return ClubModel.fromMap(clubMapData);
      }).toList());
      return likeList;
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
}