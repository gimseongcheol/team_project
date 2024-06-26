import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/like_club_widget.dart';

class SubClub extends StatefulWidget {
  const SubClub({Key? key}) : super(key: key);

  @override
  _SubClubState createState() => _SubClubState();
}

class _SubClubState extends State<SubClub> with AutomaticKeepAliveClientMixin<SubClub> {
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
    final currentUser = context.watch<User>();
    List<ClubModel> filteredClubList = clubList.where((club) => club.likes.contains(currentUser.uid)).toList();

    return SafeArea(
      //새로고침
      child: RefreshIndicator(
        onRefresh: () async{
          _getClubList();
        },
        child: ListView.builder(
          itemCount: filteredClubList.length,
          itemBuilder: (context, index){
            return LikeCardClubWidget(clubModel: filteredClubList[index]);
          },
        ),
      ),
    );
  }
}
