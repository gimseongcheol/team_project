import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/user_model.dart';

class CommentModel {
  final String commentId;
  final String comment;
  final UserModel writer;
  final Timestamp createdAt;
  final String uid;
  final String clubId;

  const CommentModel({
    required this.commentId,
    required this.comment,
    required this.writer,
    required this.createdAt,
    required this.uid,
    required this.clubId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      comment: map['comment'],
      writer: map['writer'],
      createdAt: map['createdAt'],
      uid: map['uid'],
      clubId: map['clubId'],
    );
  }

  @override
  String toString() {
    return 'CommentModel{commentId: $commentId, comment: $comment, writer: $writer, createdAt: $createdAt, uid: $uid, clubId: $clubId}';
  }
}