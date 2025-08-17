import 'package:dartz/dartz.dart';
import 'package:sputify/data/sources/song/song_firebase_service.dart';
import 'package:sputify/domain/repository/artist/artist.dart';
import 'package:sputify/service_locator.dart';

class ArtistsRepositoryImpl extends ArtistsRepository {
  @override
  Future<Either> getArtists() async {
    return await sl<SongFirebaseService>().getArtists();
  }

  @override
  Future<Either> getSongsByArtist(String artist) async {
    return await sl<SongFirebaseService>().getSongsByArtist(artist);
  }
}