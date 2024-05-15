import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/providers/comment/comment_state.dart';
import 'package:team_project/repositories/comment_repository.dart';

class CommentProvider extends StateNotifier<CommentState> with LocatorMixin {
  CommentProvider() : super(CommentState.init());

  Future<void> getCommentList({
    required String clubId,
  }) async {
    state = state.copyWith(commentStatus: CommentStatus.fetching);

    try {
      List<CommentModel> commentList =
      await read<CommentRepository>().getCommentList(clubId: clubId);

      state = state.copyWith(
        commentStatus: CommentStatus.success,
        commentList: commentList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(commentStatus: CommentStatus.error);
      rethrow;
    }
  }

  Future<void> uploadComment({
    required String clubId,
    required String uid,
    required String comment,
  }) async {
    state = state.copyWith(commentStatus: CommentStatus.submitting);

    try {
      CommentModel commentModel = await read<CommentRepository>().uploadComment(
        clubId: clubId,
        uid: uid,
        comment: comment,
      );

      state = state.copyWith(
        commentStatus: CommentStatus.success,
        commentList: [commentModel, ...state.commentList],
      );
    } on CustomException catch (_) {
      state = state.copyWith(commentStatus: CommentStatus.error);
      rethrow;
    }
  }
}