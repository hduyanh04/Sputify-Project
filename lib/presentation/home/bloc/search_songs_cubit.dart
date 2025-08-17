import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/domain/usecases/song/search_songs.dart';
import 'package:sputify/presentation/home/bloc/search_songs_state.dart';
import '../../../service_locator.dart';

class SearchSongsCubit extends Cubit<SearchSongsState> {
  final SearchSongsUseCase _useCase = sl<SearchSongsUseCase>();

  SearchSongsCubit() : super(SearchSongsInitial());

  Future<void> search(String query) async {
    emit(SearchSongsLoading());

    final result = await _useCase.call(params: query);

    result.fold(
          (l) => emit(SearchSongsError(l.toString())),
          (r) => emit(SearchSongsLoaded(r)),
    );
  }

  void clearResults() {
    emit(SearchSongsInitial());
  }
}