import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/domain/usecases/artist/get_songs_by_artist.dart';
import 'package:sputify/presentation/home/bloc/artist_songs_state.dart';
import 'package:sputify/service_locator.dart';

class ArtistSongsCubit extends Cubit<ArtistSongsState> {
  ArtistSongsCubit() : super(ArtistSongsLoading());

  Future<void> getSongsByArtist(String artist) async {
    final result = await sl<GetSongsByArtistUseCase>().call(params: artist);
    result.fold(
          (l) => emit(ArtistSongsLoadFailure()),
          (data) => emit(ArtistSongsLoaded(songs: data)),
    );
  }
}