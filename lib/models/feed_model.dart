import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';


class FeedModel {
  final String uid;
  final String clubId;
  final String feedId;
  final String desc;
  final String title;
  final List<String> imageUrls;
  final List<String> likes;
  final int likeCount;
  final Timestamp createAt;
  final UserModel writer;

  const FeedModel({
    required this.uid,
    required this.clubId,
    required this.feedId,
    required this.desc,
    required this.title,
    required this.imageUrls,
    required this.likes,
    required this.likeCount,
    required this.createAt,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
  }) {
    return {
      'uid': this.uid,
      'clubId': this.clubId,
      'feedId': this.feedId,
      'desc': this.desc,
      'title': this.title,
      'imageUrls': this.imageUrls,
      'likes': this.likes,
      'likeCount': this.likeCount,
      'createAt': this.createAt,
      'writer': userDocRef,
    };
  }

  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      uid: map['uid'],
      clubId: map['clubId'],
      feedId: map['feedId'],
      desc: map['desc'],
      title: map['title'],
      imageUrls: List<String>.from(map['imageUrls']),
      likes: List<String>.from(map['likes']),
      likeCount: map['likeCount'],
      createAt: map['createAt'],
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'FeedModel{uid: $uid,clubId: $clubId, feedId: $feedId, desc: $desc,title: $title, imageUrls: $imageUrls, likes: $likes, likeCount: $likeCount, createAt: $createAt, writer: $writer}';
  }
}