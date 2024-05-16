import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';


class NoticeModel {
  final String uid;
  final String clubId;
  final String noticeId;
  final String desc;
  final String title;
  final List<String> imageUrls;
  final Timestamp createAt;
  final UserModel writer;

  const NoticeModel({
    required this.uid,
    required this.clubId,
    required this.noticeId,
    required this.desc,
    required this.title,
    required this.imageUrls,
    required this.createAt,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
  }) {
    return {
      'uid': this.uid,
      'clubId': this.clubId,
      'noticeId': this.noticeId,
      'desc': this.desc,
      'title': this.title,
      'imageUrls': this.imageUrls,
      'createAt': this.createAt,
      'writer': userDocRef,
    };
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      uid: map['uid'],
      clubId: map['clubId'],
      noticeId: map['noticeId'],
      desc: map['desc'],
      title: map['title'],
      imageUrls: List<String>.from(map['imageUrls']),
      createAt: map['createAt'],
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'NoticeModel{uid: $uid,clubId: $clubId, noticeId: $noticeId, desc: $desc,title: $title, imageUrls: $imageUrls, createAt: $createAt, writer: $writer}';
  }
}