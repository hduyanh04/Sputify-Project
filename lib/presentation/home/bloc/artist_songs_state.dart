import 'package:sputify/domain/entities/song/song.dart';

abstract class ArtistSongsState {}

class ArtistSongsLoading extends ArtistSongsState {}

class ArtistSongsLoaded extends ArtistSongsState {
  final List<SongEntity> songs;
  ArtistSongsLoaded({required this.songs});
}

class ArtistSongsLoadFailure extends ArtistSongsState {}