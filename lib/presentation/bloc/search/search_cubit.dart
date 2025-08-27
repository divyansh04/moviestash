import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moviestash/core/utils/result.dart';
import 'package:moviestash/domain/entities/movie.dart';
import 'package:moviestash/domain/usecases/search_movies.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {

  SearchCubit({required this.searchMovies}) : super(SearchInitial());
  final SearchMovies searchMovies;
  Timer? _debounceTimer;

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      submit(query);
    });
  }

  Future<void> submit(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMovies(SearchMoviesParams(query: query));

    if (result.isSuccess) {
      emit(SearchLoaded(result.data!));
    } else {
      emit(SearchError(result.exception!.message));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
