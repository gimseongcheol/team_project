import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/avatar_widget.dart';

class CommentCardWidget extends StatefulWidget {
  final CommentModel commentModel;

  const CommentCardWidget({
    super.key,
    required this.commentModel,
  });

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  @override
  Widget build(BuildContext context) {
    CommentModel commentModel = widget.commentModel;
    UserModel writer = commentModel.writer;
    final _themeManager = Provider.of<ThemeManager>(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 13,
        right: 13,
      ),
      child: Row(
        children: [
          AvatarWidget(userModel: writer),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: writer.userid +' '+ writer.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.white70
                        : Colors.black,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 10)),
                TextSpan(
                  text: commentModel.comment,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.white70
                        : Colors.black,
                  ),
                ),
              ])),
              SizedBox(height: 4),
              Text(
                commentModel.createdAt.toDate().toString().split(' ')[0],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white70
                      : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
