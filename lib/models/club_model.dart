class ClubModel {
  final String clubId;
  final String clubType;
  final String clubName;
  final String writer;
  final String professorName;
  final String call;
  final String shortComment;
  final String fullComment;
  final List<String> profileImageUrl;
  final List<String> followers;
  final int commentCount;
  final int noticeCount;
  //final int followersCount;
  final List<String> likes;

  const ClubModel({
    required this.clubId,
    required this.clubType,
    required this.clubName,
    required this.writer,
    required this.professorName,
    required this.call,
    required this.shortComment,
    required this.fullComment,
    required this.profileImageUrl,
    required this.followers,
    required this.commentCount,
    required this.noticeCount,
    required this.likes,
  });

  ClubModel copyWith({
    String? clubId,
    String? clubName,
    String? clubType,
    String? writer,
    String? professorName,
    String? call,
    String? shortComment,
    String? fullComment,
    List<String>? profileImageUrl,
    List<String>? followers,
    int? commentCount,
    int? noticeCount,
    List<String>? likes,
  }) {
    return ClubModel(
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      clubType: clubType ?? this.clubType,
      writer: writer ?? this.writer,
      professorName: professorName ?? this.professorName,
      call: call ?? this.call,
      shortComment: shortComment ?? this.shortComment,
      fullComment: fullComment ?? this.fullComment,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      commentCount: commentCount ?? this.commentCount,
      noticeCount: noticeCount ?? this.noticeCount,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clubId': this.clubId,
      'clubName': this.clubName,
      'clubType' : this.clubType,
      'writer': this.writer,
      'professorName': this.professorName,
      'call': this.call,
      'shortComment': this.shortComment,
      'fullComment' : this.fullComment,
      'profileImageUrl': this.profileImageUrl,
      'followers': this.followers,
      'commentCount': this.commentCount,
      'noticeCount' : this.noticeCount,
      'likes': this.likes,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      clubId: map['clubId'] as String,
      clubName: map['clubName'] as String,
      clubType: map['clubtype'] as String,
      writer: map['writer'] as String,
      professorName: map['professorName'] as String,
      call: map['call'] as String,
      shortComment: map['shortComment'] as String,
      fullComment: map['fullComemnt'] as String,
      profileImageUrl: map['profileImageUrl'] as List<String>,
      followers: map['followers'] as List<String>,
      commentCount: map['commentCount'] as int,
      noticeCount: map['noticeCount'] as int,
      likes: map['likes'] as List<String>,
    );
  }

  @override
  String toString() {
    return 'ClubModel{clubId: $clubId, clubName: $clubName, writer: $writer, professorName: $professorName, call: $call, ShortComment: $shortComment, fullComment: $fullComment, profileImageUrl: $profileImageUrl, followers: $followers, commentCount: $commentCount, noticeCount : $noticeCount, likes: $likes}';
  }
}