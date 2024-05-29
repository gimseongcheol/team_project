import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';

class ReportRepository {
  final FirebaseFirestore firebaseFirestore;

  const ReportRepository({
    required this.firebaseFirestore,
  });

  Future<List<ClubModel>> getReportList({
    required String uid,
    required int reportLength,
    String? clubId,
  }) async {
    try {
      Map<String, dynamic> userMapData = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.data()!);

      List<String> reports = List<String>.from(userMapData['reports']);

      if (clubId != null) {
        int startIdx = reports.indexWhere((element) => element == clubId) + 1;
        int endIdx = (startIdx + reportLength) > reports.length
            ? reports.length
            : startIdx + reportLength;
        reports = reports.sublist(startIdx, endIdx);
      } else {
        int endIdx = reports.length < reportLength ? reports.length : reportLength;
        reports = reports.sublist(0, endIdx);
      }

      List<ClubModel> reportList = await Future.wait(reports.map((clubId) async {
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
      return reportList;
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
}