import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/search/search_state.dart';
import 'package:team_project/repositories/search_repository.dart';

class SearchProvider extends StateNotifier<SearchState> with LocatorMixin {
  SearchProvider() : super(SearchState.init());

  void clear() {
    state = state.copyWith(clubModelList: []);
  }

  Future<void> searchClub({
    required String keyword,
  }) async {
    state = state.copyWith(searchStatus: SearchStatus.searching);

    try {
      List<ClubModel> clubModelList =
      await read<SearchRepository>().searchClub(keyword: keyword);
      state = state.copyWith(
        searchStatus: SearchStatus.success,
        clubModelList: clubModelList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(searchStatus: SearchStatus.error);
      rethrow;
    }
  }
}