import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;

  const ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<UserModel> getProfile({
    required String uid,
  }) async {
    try {
      //doc으로 가져오면 DocumentReference, get으로 가져오면 DocumentSnapShot
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firebaseFirestore.collection('users').doc(uid).get();
      //map -> usermodel로 변환
      return UserModel.fromMap(snapshot.data()!);
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
