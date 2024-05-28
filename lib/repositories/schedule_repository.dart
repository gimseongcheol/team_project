import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/schedule_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ScheduleRepository {
  final FirebaseFirestore firebaseFirestore;

  const ScheduleRepository({
    required this.firebaseFirestore,
  });

  Future<List<ScheduleModel>> getScheduleList({
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
          .collection('schedules')
          .orderBy('createAt', descending: true);

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
        await writerDocRef.get();
        UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
        data['writer'] = userModel;
        return ScheduleModel.fromMap(data);
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

  Future<ScheduleModel> uploadSchedule({
    required String cont,
    required String uid,
    required String clubId,
  }) async {
    List<String> imageUrls = [];
    try {
      WriteBatch batch = firebaseFirestore.batch();

      String scheduleId = Uuid().v1();
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
      clubDocRef.collection('schedules').doc(scheduleId);

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      ScheduleModel scheduleModel = ScheduleModel.fromMap({
        'uid': uid,
        'clubId': clubId,
        'scheduleId': scheduleId,
        'cont': cont,
        'dateTime': DateTime,
        'createAt': Timestamp.now(),
        'writer': userModel,
      });

      return scheduleModel;
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