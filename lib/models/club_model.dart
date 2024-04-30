import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/user_model.dart';

class ClubModel {
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
  final int noticeCount;
  final String depart;
  //final int followersCount;
  final List<String> likes;

  const ClubModel({
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
    required this.noticeCount,
    required this.depart,
    required this.likes,
  });


  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
}) {
    return {
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
      'noticeCount' : this.noticeCount,
      'depart' : this.depart,
      'likes': this.likes,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      clubId: map['clubId'],
      clubName: map['clubName'],
      clubType: map['clubtype'],
      writer: map['writer'],
      createAt: map['createAt'],
      presidentName: map['presidentName'],
      professorName: map['professorName'],
      call: map['call'],
      shortComment: map['shortComment'],
      fullComment: map['fullComemnt'],
      profileImageUrl: List<String>.from(map['profileImageUrl']),
      commentCount: map['commentCount'],
      noticeCount: map['noticeCount'],
      depart: map['depart'],
      likes: List<String>.from(map['likes']),
    );
  }

  @override
  String toString() {
    return 'ClubModel{clubId: $clubId, clubName: $clubName, writer: $writer,createAt: $createAt, presidentName: $presidentName, professorName: $professorName, call: $call, ShortComment: $shortComment, fullComment: $fullComment, profileImageUrl: $profileImageUrl, commentCount: $commentCount, noticeCount : $noticeCount, depart : $depart, likes: $likes}';
  }
}