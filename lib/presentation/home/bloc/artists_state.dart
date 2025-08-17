
import 'package:sputify/domain/entities/artist/artist.dart';

abstract class ArtistsState {}

class ArtistsLoading extends ArtistsState {}

class ArtistsLoaded extends ArtistsState {
  final List<ArtistEntity> artists;
  ArtistsLoaded({required this.artists});
}

class ArtistsLoadFailure extends ArtistsState {}