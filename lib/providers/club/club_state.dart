import 'package:team_project/models/club_model.dart';

enum ClubStatus {
  init,
  submitting,
  fetching,
  reFetching,
  success,
  error,
}

class ClubState {
  final ClubStatus clubStatus;
  final List<ClubModel> clubList;
  final bool hasNext;

  const ClubState({
    required this.clubStatus,
    required this.clubList,
    required this.hasNext,
  });

  factory ClubState.init() {
    return ClubState(
      clubStatus: ClubStatus.init,
      clubList: [],
      hasNext: true,
    );
  }

  ClubState copyWith({
    ClubStatus? clubStatus,
    List<ClubModel>? clubList,
    bool? hasNext,
  }) {
    return ClubState(
      clubStatus: clubStatus ?? this.clubStatus,
      clubList: clubList ?? this.clubList,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
