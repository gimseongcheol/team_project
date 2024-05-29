import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/comment/comment_provider.dart';
import 'package:team_project/providers/comment/comment_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/comment_widget.dart';
import 'package:team_project/widgets/edit_cardClub.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class EditComment extends StatefulWidget {

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment>
    with AutomaticKeepAliveClientMixin<EditComment> {
  late final ClubProvider clubProvider;
  late final CommentProvider commentProvider;
  late List<String> clubIds;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    commentProvider = context.read<CommentProvider>();
    _getCommentList();
  }

  Future<void> _getCommentList() async {
    try {
      final clubList = context.read<ClubState>().clubList;
      for (var club in clubList) {
        await commentProvider.getCommentList(clubId: club.clubId);
      }
    } on CustomException catch (e) {
      errorDialogWidget(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CommentState commentState = context.watch<CommentState>();
    List<CommentModel> allComments = commentState.commentList;
    ClubState clubState = context.watch<ClubState>();
    final clubList = context.read<ClubState>().clubList;

    // 현재 사용자가 작성한 댓글만 필터링
    final currentUser = context.watch<User>();
    List<CommentModel> userComments = allComments.where((comment) => comment.uid == currentUser.uid).toList();

    return SafeArea(
      // Refresh
      child: RefreshIndicator(
        onRefresh: _getCommentList,
        child: ListView.builder(
          itemCount: userComments.length,
          itemBuilder: (context, index) {
            CommentModel commentModel = userComments[index];
            // Finding the associated ClubModel for each comment
            ClubModel? clubModel = clubList.firstWhere(
                  (club) => club.clubId == commentModel.clubId,
              orElse: () => ClubModel(uid: clubList[index].uid, clubId: clubList[index].clubId, clubType: clubList[index].clubType, clubName: clubList[index].clubName, writer: clubList[index].writer, createAt: clubList[index].createAt, presidentName: clubList[index].presidentName, professorName: clubList[index].professorName, call: clubList[index].call, shortComment: clubList[index].shortComment, fullComment: clubList[index].fullComment, profileImageUrl: clubList[index].profileImageUrl, commentCount: clubList[index].commentCount, feedCount: clubList[index].feedCount, noticeCount: clubList[index].noticeCount, depart: clubList[index].depart, likes: clubList[index].likes, likeCount: clubList[index].likeCount, reports: clubList[index].reports,reportCount: clubList[index].reportCount),
            );

            return CommentCardClubWidget(clubModel: clubModel,commentModel: commentModel);
          },
        ),
      ),
    );
  }
}