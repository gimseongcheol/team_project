import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/club_model.dart';


class NoticeModel {
  final String uid;
  final String noticeId;
  final String title;
  final String desc;
  final String? imageUrls;
  final Timestamp createAt;
  final ClubModel writer;

  const NoticeModel({
    required this.uid,
    required this.noticeId,
    required this.title,
    required this.desc,
    required this.imageUrls,
    required this.createAt,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> clubDocRef,
  }) {
    return {
      'uid': this.uid,
      'noticeId': this.noticeId,
      'title': this.title,
      'desc': this.desc,
      'imageUrls': this.imageUrls,
      'createAt': this.createAt,
      'writer': clubDocRef,
    };
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      uid: map['uid'],
      noticeId: map['noticeId'],
      title: map['title'],
      desc: map['desc'],
      imageUrls: map['imageUrls'],
      createAt: map['createAt'],
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'NoticeModel{uid: $uid, noticeId: $noticeId,title, $title, desc: $desc, imageUrls: $imageUrls, createAt: $createAt, writer: $writer}';
  }
}