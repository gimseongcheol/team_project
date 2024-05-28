import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';

class ScheduleModel {
  final int cont;
  final DateTime dateTime;
  final ClubModel clubId;
  final String scheduleId;
  final Timestamp createAt;
  final String uid;
  final UserModel writer;

  ScheduleModel({
    required this.cont,
    required this.dateTime,
    required this.clubId,
    required this.scheduleId,
    required this.createAt,
    required this.uid,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
}) {
    return {
      'cont': this.cont,
      'dateTime': this.dateTime,
      'clubId': this.clubId,
      'scheduleId': this.scheduleId,
      'createAt': this.createAt,
      'uid': this.uid,
      'writer': userDocRef,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      cont: map['cont'],
      dateTime: map['dateTime'],
      clubId: map['clubId'],
      scheduleId: map['scheduleId'],
      createAt: map['createAt'],
      uid: map['uid'],
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'ScheduleModel{cont: $cont, dateTime: $dateTime, clubId: $clubId, scheduleId: $scheduleId, createAt: $createAt, uid: $uid, writer: $writer}';
  }
}
