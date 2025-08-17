import 'package:sputify/domain/entities/song/song.dart';

abstract class SearchSongsState {}

class SearchSongsInitial extends SearchSongsState {}

class SearchSongsLoading extends SearchSongsState {}

class SearchSongsLoaded extends SearchSongsState {
  final List<SongEntity> songs;
  SearchSongsLoaded(this.songs);
}

class SearchSongsError extends SearchSongsState {
  final String message;
  SearchSongsError(this.message);
}