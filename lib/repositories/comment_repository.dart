import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:uuid/uuid.dart';

class CommentRepository {
  final FirebaseFirestore firebaseFirestore;

  const CommentRepository({
    required this.firebaseFirestore,
  });
  Future<void> deleteComment({
    required ClubModel clubModel,
    required CommentModel commentModel, // 삭제할 댓글의 ID
  }) async {
    try {
      WriteBatch batch = firebaseFirestore.batch();
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubModel.clubId);

      // 주어진 commentId에 해당하는 댓글을 삭제합니다.
      DocumentReference<Map<String, dynamic>> commentDocRef =
      firebaseFirestore.collection('comments').doc(commentModel.commentId);
      batch.delete(commentDocRef);

      // 해당 댓글이 삭제되었으므로, clubDocRef의 commentCount를 1 감소시킵니다.
      batch.update(clubDocRef, {
        'commentCount': FieldValue.increment(-1),
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

  Future<List<CommentModel>> getCommentList({
    required String clubId,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      List<CommentModel> commentList =
      await Future.wait(snapshot.docs.map((e) async {
        Map<String, dynamic> data = e.data();
        DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
        Map<String, dynamic> writerMapData =
        await writerDocRef.get().then((value) => value.data()!);
        data['writer'] = UserModel.fromMap(writerMapData);
        return CommentModel.fromMap(data);
      }).toList());
      return commentList;
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

  Future<CommentModel> uploadComment({
    required String clubId,
    required String uid,
    required String comment,
  }) async {
    try {
      String commentId = Uuid().v1();

      DocumentReference<Map<String, dynamic>> writerDocRef =
      firebaseFirestore.collection('users').doc(uid);
      DocumentReference<Map<String, dynamic>> clubDocRef =
      firebaseFirestore.collection('clubs').doc(clubId);
      DocumentReference<Map<String, dynamic>> commentDocRef =
      firebaseFirestore.collection('comments').doc(commentId);

      await firebaseFirestore.runTransaction((transaction) async {
        transaction.set(commentDocRef, {
          'commentId': commentId,
          'comment': comment,
          'writer': writerDocRef,
          'createdAt': Timestamp.now(),
          'uid': uid,
          'clubId': clubId,
        });

        transaction.update(clubDocRef, {
          'commentCount': FieldValue.increment(1),
        });
      });

      UserModel userModel = await writerDocRef.get().then((snapshot) =>
      snapshot.data()!).then((data) => UserModel.fromMap(data));

      CommentModel commentModel = await commentDocRef.get().then((snapshot) => snapshot.data()!).then((data) {
        data['writer'] = userModel;
        return CommentModel.fromMap(data);
      });
      return commentModel;
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