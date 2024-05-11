import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';


class FeedModel {
  final String clubId;
  final String feedId;
  final String desc;
  final String title;
  final List<String> imageUrls;
  final List<String> likes;
  final int commentCount;
  final int likeCount;
  final Timestamp createAt;
  final ClubModel writer;

  const FeedModel({
    required this.clubId,
    required this.feedId,
    required this.desc,
    required this.title,
    required this.imageUrls,
    required this.likes,
    required this.commentCount,
    required this.likeCount,
    required this.createAt,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> clubDocRef,
  }) {
    return {
      'clubId': this.clubId,
      'feedId': this.feedId,
      'desc': this.desc,
      'title': this.title,
      'imageUrls': this.imageUrls,
      'likes': this.likes,
      'commentCount': this.commentCount,
      'likeCount': this.likeCount,
      'createAt': this.createAt,
      'writer': clubDocRef,
    };
  }

  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      clubId: map['clubId'],
      feedId: map['feedId'],
      desc: map['desc'],
      title: map['title'],
      imageUrls: List<String>.from(map['imageUrls']),
      likes: List<String>.from(map['likes']),
      commentCount: map['commentCount'],
      likeCount: map['likeCount'],
      createAt: map['createAt'],
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'FeedModel{clubId: $clubId, feedId: $feedId, desc: $desc,title: $title, imageUrls: $imageUrls, likes: $likes, commentCount: $commentCount, likeCount: $likeCount, createAt: $createAt, writer: $writer}';
  }
}