import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/screen/modify/ModifyPostScreen.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/ModifyClubScreen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/edit_cardClub.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class EditClub extends StatefulWidget {
  @override
  _EditClubState createState() => _EditClubState();
}

class _EditClubState extends State<EditClub>
    with AutomaticKeepAliveClientMixin<EditClub> {
  late final ClubProvider clubProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    clubProvider = context.read<ClubProvider>();
    _getClubList();
  }

  void _getClubList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await clubProvider.getClubList();
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ClubState clubState = context.watch<ClubState>();
    List<ClubModel> clubList = clubState.clubList;
    final _themeManager = Provider.of<ThemeManager>(context);
    final currentUser = context.watch<User>();
    return SafeArea(
      //새로고침
      child: RefreshIndicator(
        onRefresh: () async{
          _getClubList();
        },
        child: ListView.builder(
          itemCount: clubList.length,
          itemBuilder: (context, index){
            ClubModel clubModel = clubList[index];
            // currentUser와 clubModel.writer가 동일한지 확인
            if (currentUser.uid == clubModel.uid) {
              return EditCardClubWidget(clubModel: clubList[index]);
            } else {
              return Container(); // 아무것도 렌더링하지 않음
            }
          },
        ),
      ),
    );
  }
}
