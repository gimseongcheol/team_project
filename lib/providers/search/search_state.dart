import 'package:team_project/models/club_model.dart';

enum SearchStatus {
  init,
  searching,
  success,
  error,
}

class SearchState {
  final SearchStatus searchStatus;
  final List<ClubModel> clubModelList;

  const SearchState({
    required this.searchStatus,
    required this.clubModelList,
  });

  factory SearchState.init() {
    return SearchState(
      searchStatus: SearchStatus.init,
      clubModelList: [],
    );
  }

  SearchState copyWith({
    SearchStatus? searchStatus,
    List<ClubModel>? clubModelList,
  }) {
    return SearchState(
      searchStatus: searchStatus ?? this.searchStatus,
      clubModelList: clubModelList ?? this.clubModelList,
    );
  }

  @override
  String toString() {
    return 'SearchState{searchStatus: $searchStatus, clubModelList: $clubModelList}';
  }
}