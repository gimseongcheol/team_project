import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/comment/comment_provider.dart';
import 'package:team_project/providers/comment/comment_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/widgets/avatar_widget.dart';
import 'package:team_project/widgets/cooment_card_widget.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'DescriptionScreen.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class CommentScreen extends StatefulWidget {
  final String clubId;

  const CommentScreen({super.key, required this.clubId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CommentProvider commentProvider;

  @override
  void initState() {
    super.initState();
    commentProvider = context.read<CommentProvider>();
    _getCommentList();
  }
  void _getCommentList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await commentProvider.getCommentList(clubId: widget.clubId);
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    UserModel currentUserModel = context.read<UserState>().userModel;
    CommentState commentState = context.watch<CommentState>();
    bool isEnabled = commentState.commentStatus != CommentStatus.submitting;
    final _themeManager = Provider.of<ThemeManager>(context);

    if (commentState.commentStatus == CommentStatus.fetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: commentState.commentList.length,
          itemBuilder: (context, index) {
            if (commentState.commentList[index].clubId == widget.clubId) {
              return CommentCardWidget(
                commentModel: commentState.commentList[index],
              );
            } else {
              // 클럽 ID가 일치하지 않으면 빈 컨테이너 반환
              return SizedBox.shrink();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: _themeManager.themeMode == ThemeMode.dark
            ? Colors.black54
            : Colors.white70,
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              AvatarWidget(userModel: currentUserModel),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextFormField(
                    controller: commentController,
                    enabled: isEnabled,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해주세요',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.black54,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '댓글을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: isEnabled ? () async {
                  FocusScope.of(context).unfocus();

                  FormState? form = _formKey.currentState;

                  if (form == null || !form.validate()) {
                    return;
                  }

                  try {
                    // 댓글 등록 로직
                    await context.read<CommentProvider>().uploadComment(
                      clubId: widget.clubId,
                      uid: currentUserModel.uid,
                      comment: commentController.text,
                    );
                  } on CustomException catch (e) {
                    errorDialogWidget(context, e);
                  }

                  commentController.clear();
                } : null,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}