import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/user_model.dart';

class ClubModel {
  final String uid;
  final String clubId;
  final String clubType;
  final String clubName;
  final UserModel writer;
  final Timestamp createAt;
  final String presidentName;
  final String professorName;
  final String call;
  final String shortComment;
  final String fullComment;
  final List<String> profileImageUrl;
  final int commentCount;
  final int feedCount;
  final int noticeCount;
  final String depart;
  //final int followersCount;
  final List<String> likes;
  final int likeCount;
  final List<String> reports;
  final int reportCount;

  const ClubModel({
    required this.uid,
    required this.clubId,
    required this.clubType,
    required this.clubName,
    required this.writer,
    required this.createAt,
    required this.presidentName,
    required this.professorName,
    required this.call,
    required this.shortComment,
    required this.fullComment,
    required this.profileImageUrl,
    required this.commentCount,
    required this.feedCount,
    required this.noticeCount,
    required this.depart,
    required this.likes,
    required this.likeCount,
    required this.reports,
    required this.reportCount,
  });


  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
  }) {
    return {
      'uid': this.uid,
      'clubId': this.clubId,
      'clubName': this.clubName,
      'clubType' : this.clubType,
      'writer': userDocRef,
      'createAt': this.createAt,
      'presidentName': this.presidentName,
      'professorName': this.professorName,
      'call': this.call,
      'shortComment': this.shortComment,
      'fullComment' : this.fullComment,
      'profileImageUrl': this.profileImageUrl,
      'commentCount': this.commentCount,
      'feedCount': this.feedCount,
      'noticeCount' : this.noticeCount,
      'depart' : this.depart,
      'likes': this.likes,
      'likeCount': this.likeCount,
      'reports': this.reports,
      'reportCount': this.reportCount,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      uid:map['uid'],
      clubId: map['clubId'],
      clubName: map['clubName'],
      clubType: map['clubType'],
      writer: map['writer'],
      createAt: map['createAt'],
      presidentName: map['presidentName'],
      professorName: map['professorName'],
      call: map['call'],
      shortComment: map['shortComment'],
      fullComment: map['fullComment'],
      profileImageUrl: List<String>.from(map['profileImageUrl']),
      commentCount: map['commentCount'],
      feedCount: map['feedCount'],
      noticeCount: map['noticeCount'],
      depart: map['depart'],
      likes: List<String>.from(map['likes']),
      likeCount: map['likeCount'],
      reports: List<String>.from(map['reports']),
      reportCount: map['reportCount'],
    );
  }

  @override
  String toString() {
    return 'ClubModel{uid: $uid, clubId: $clubId, clubName: $clubName, writer: $writer,createAt: $createAt, presidentName: $presidentName, professorName: $professorName, call: $call, shortComment: $shortComment, fullComment: $fullComment, profileImageUrl: $profileImageUrl, commentCount: $commentCount,feedCount: $feedCount, noticeCount : $noticeCount, depart : $depart, likes: $likes, likeCount : $likeCount, reports: $reports, reportCount : $reportCount}';
  }
}