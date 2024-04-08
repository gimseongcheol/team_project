import 'package:team_project/models/club_model.dart';

enum ClubStatus {
  init,
  submitting,
  fetching,
  success,
  error,
}

class ClubState {
  final ClubStatus clubStatus;
  final List<ClubModel> clubList;

  const ClubState({
    required this.clubStatus,
    required this.clubList,
  });

  factory ClubState.init() {
    return ClubState(
      clubStatus: ClubStatus.init,
      clubList: [],
    );
  }

  ClubState copyWith({
    ClubStatus? clubStatus,
    List<ClubModel>? clubList,
  }) {
    return ClubState(
      clubStatus: clubStatus ?? this.clubStatus,
      clubList: clubList ?? this.clubList,
    );
  }
}
