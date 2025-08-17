import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/domain/usecases/artist/get_artists.dart';
import 'package:sputify/presentation/home/bloc/artists_state.dart';
import 'package:sputify/service_locator.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  ArtistsCubit() : super(ArtistsLoading());

  Future<void> getArtists() async {
    final result = await sl<GetArtistsUseCase>().call();
    result.fold(
          (l) => emit(ArtistsLoadFailure()),
          (data) => emit(ArtistsLoaded(artists: data)),
    );
  }
}