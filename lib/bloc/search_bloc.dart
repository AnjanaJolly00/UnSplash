import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash/data/api_response.dart';
import 'package:unsplash/data/search_api_response.dart';
import 'package:unsplash/network/api_service.dart';
import 'package:unsplash/bloc/search_event.dart';
import 'package:unsplash/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitialState()) {
    on<SearchEvent>(onSearchEvent);
  }

  ApiService apiService = ApiService();
  List<SearchResults> results = [];
  int pageNum = 1;
  bool canLoadMore = true;

  Future<void> onSearchEvent(SearchEvent event, Emitter emit) async {
    ApiResponse response;
    emit(SearchLoadingState());
    if (event.loadMore! && canLoadMore) {
      pageNum++;
    }
    try {
      response = await apiService.getSearchResults(event.searchValue, pageNum);
      if (response.isSuccessful &&
          response.rawResponse!.isNotEmpty &&
          response != null) {
        SearchApiResponse searchApiResponse =
            SearchApiResponse.fromMap(response.rawResponse);
        results.addAll(searchApiResponse.searchResults!);
        if (searchApiResponse.total == results.length) {
          canLoadMore = false;
        }
        emit(SearchSuccessState());
      }
    } on Error catch (error) {
      emit(SearchFailureState(errorMsg: error.toString()));
    }
  }
}
