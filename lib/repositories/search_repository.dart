import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';

class SearchRepository {
  final FirebaseFirestore firebaseFirestore;

  const SearchRepository({
    required this.firebaseFirestore,
  });

  Future<List<ClubModel>> searchClub({
    required String keyword,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await firebaseFirestore
          .collection('clubs')
          .where('clubName', isGreaterThanOrEqualTo: keyword)
          .where('clubName', isLessThanOrEqualTo: keyword + '\uf7ff')
          .get();

      List<ClubModel> clubList = querySnapshot.docs
          .map((club) => ClubModel.fromMap(club.data()))
          .toList();
      return clubList;
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
}